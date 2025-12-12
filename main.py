import sys
import time
from clingo.application import Application, clingo_main


class AnalysisASP(Application):
    def __init__(self, name: str):
        self.program_name = name
        self.version = "1.0"
        self._start_time = None
        self._fh = None  

    def _log(self, msg: str = ""):
        if self._fh is not None:
            print(msg, file=self._fh)
            self._fh.flush() 

    # called on each model
    def _on_model(self, model):
        self._log(f"Model {model.number} found, cost = {model.cost}")
        return False

    def main(self, ctl, files):
        out_path = "analysis_stats.txt"
        with open(out_path, "w") as fh:
            self._fh = fh
            if files:
                for f in files:
                    ctl.load(f)
                    self._log(f"Loaded: {f}")
            else:
                ctl.load("-")
                self._log("Loaded program from stdin")

            self._start_time = time.perf_counter()
            self._log("Grounding parts: base, flow")
            ctl.ground([("base", [])])
            ctl.ground([("flow", [])])
            self._log("Starting solve() (stop after first model)")
            result = ctl.solve(on_model=self._on_model)
            end_time = time.perf_counter()
            total_time = end_time - self._start_time

            self._log("\n=== Solve result ===")
            self._log(str(result))  # SATISFIABLE / OPTIMUM FOUND / UNSATISFIABLE
            self._log(f"Total time (grounding + solving): {total_time:.3f}s\n")
            stats = ctl.statistics

            def get(path, default=None):
                d = stats
                for key in path:
                    if isinstance(d, dict) and key in d:
                        d = d[key]
                    else:
                        return default
                return d

            # summary info
            models_enum = get(["summary", "models", "enumerated"], 0)
            solves = get(["summary", "solves"], 0)
            time_total = get(["summary", "times", "total"], 0.0)
            time_solve = get(["summary", "times", "solve"], 0.0)
            time_model = get(["summary", "times", "model"], 0.0)

            # solver core stats (first solver)
            solver_stats = get(["solving", "solvers", 0], {})
            choices = solver_stats.get("choices", 0)
            conflicts = solver_stats.get("conflicts", 0)
            restarts = solver_stats.get("restarts", 0)

            self._log("=== Basic clingo statistics ===")
            self._log(f" Models enumerated : {models_enum}")
            self._log(f" Solve calls       : {solves}")
            self._log(f" Choices           : {choices}")
            self._log(f" Conflicts         : {conflicts}")
            self._log(f" Restarts          : {restarts}")
            self._log(f" Time (total)      : {time_total:.3f}s")
            self._log(f" Time (solve)      : {time_solve:.3f}s")
            self._log(f" Time (model)      : {time_model:.3f}s")


if __name__ == "__main__":
    clingo_main(AnalysisASP("analysis"))
