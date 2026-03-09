"""
RealBench reference solution PPA 추출 스크립트
각 문제의 {benchmark_path}/verification/{problem_name}_ref.sv를 합성하여 PPA를 추출하고
{benchmark_path}/{problem_name}_ppa.txt로 저장합니다.
"""

import os
import sys
import tempfile
import shutil

# 프로젝트 루트 경로 설정
PROJECT_ROOT = "/workspace"
sys.path.insert(0, PROJECT_ROOT)

from src.revolution.evaluation import RealBenchSynthesis
from data.bench.RealBench.benchmark_info import benchmark_info

REALBENCH_PATH = os.path.join(PROJECT_ROOT, "data", "bench", "RealBench")



def extract_ref_ppa(problem_name: str, system_name: str, synthesis_evaluator: RealBenchSynthesis):
    """
    주어진 문제의 _ref.sv를 합성하여 PPA를 추출하고 _ppa.txt로 저장.
    """
    verification_dir = os.path.join(REALBENCH_PATH, system_name, problem_name, "verification")
    ref_sv = os.path.join(verification_dir, f"{problem_name}_ref.sv")
    output_ppa_path = os.path.join(REALBENCH_PATH, system_name, problem_name, f"{problem_name}_ppa.txt")

    # 이미 존재하면 스킵
    if os.path.exists(output_ppa_path):
        print(f"[SKIP] {problem_name}: PPA already exists at {output_ppa_path}")
        return True

    if not os.path.exists(ref_sv):
        print(f"[SKIP] {problem_name}: ref.sv not found at {ref_sv}")
        return False

    # 임시 출력 디렉토리 생성
    with tempfile.TemporaryDirectory() as tmp_dir:
        # ref.sv를 tmp_dir에 복사 (합성 시 verification 폴더 탐색을 위해)
        tmp_ref_sv = os.path.join(tmp_dir, f"{problem_name}_ref.sv")
        shutil.copy(ref_sv, tmp_ref_sv)

        # verification 폴더도 tmp_dir 하위에 심링크 또는 복사
        tmp_verification_dir = os.path.join(tmp_dir, "verification")
        if os.path.exists(verification_dir):
            shutil.copytree(verification_dir, tmp_verification_dir)

        report_base_path = os.path.join(tmp_dir, problem_name)
        synthesized_netlist_path = os.path.join(tmp_dir, f"{problem_name}.syn.v")

        print(f"[RUN] {problem_name}: Synthesizing ref.sv ...")
        
        ''' for DEBUGGING
        print(f"  [DEBUG] verilog_file: {tmp_ref_sv}")
        if os.path.exists(tmp_verification_dir):
            all_files = os.listdir(tmp_verification_dir)
            design_files = [f for f in all_files
                if (f.endswith(".v") or f.endswith(".sv"))
                and not any(ex in f for ex in ["_ref", "_testbench", "_stimulus_gen", "_top"])]
            print(f"  [DEBUG] verification_dir all files: {all_files}")
            print(f"  [DEBUG] design_files filtered: {design_files}")
        else:
            print(f"  [DEBUG] verification_dir not found: {tmp_verification_dir}")
        '''

        success, report_path = synthesis_evaluator._run_synthesis(
            verilog_file=tmp_ref_sv,
            problem_name=problem_name,
            synth_top_module_name=f"ref_{problem_name}",
            output_directory=tmp_dir,
            report_base_path=report_base_path,
            synthesized_netlist_path=synthesized_netlist_path,
            synthesis_timeout_s=7200,
        )

        if not success:
            print(f"[FAIL] {problem_name}: Synthesis failed.")
            if report_path and os.path.exists(report_path):
                with open(report_path, "r") as f:
                    print(f"  [REPORT]\n{f.read()[-3000:]}")
            else:
                # report가 없으면 yosys 직접 실행해서 에러 확인
                print(f"  [REPORT] report_path not found: {report_path}")
                # yosys script가 생성됐으면 직접 실행
                yosys_script = os.path.join(tmp_dir, f"ref_{problem_name}.yosys.tcl")
                if os.path.exists(yosys_script):
                    import subprocess
                    result = subprocess.run(
                        f"yosys {yosys_script}",
                        shell=True, capture_output=True, text=True
                    )
                    print(f"  [YOSYS STDERR]\n{result.stderr[-3000:]}")
                    print(f"  [YOSYS STDOUT]\n{result.stdout[-3000:]}")
            return False


        # PPA 파싱
        ppa_metrics = synthesis_evaluator._parse_ppa_log(report_path)

        if ppa_metrics["tns"] is None:
            print(f"[FAIL] {problem_name}: PPA parsing failed.")
            return False

        # _ppa.txt 저장
        os.makedirs(os.path.dirname(output_ppa_path), exist_ok=True)
        with open(output_ppa_path, "w") as f:
            f.write("tns,wns,eff_clk_period,power,area\n")
            f.write(f"{ppa_metrics['tns']},{ppa_metrics['wns']},{ppa_metrics['eff_clk_period']},{ppa_metrics['power']},{ppa_metrics['area']}")

        print(f"[OK] {problem_name}: PPA saved to {output_ppa_path}")
        print(f"     tns={ppa_metrics['tns']}, wns={ppa_metrics['wns']}, "
              f"eff_clk_period={ppa_metrics['eff_clk_period']}, "
              f"power={ppa_metrics['power']}, area={ppa_metrics['area']}")
        return True


def main():
    synthesis_evaluator = RealBenchSynthesis()

    success_list = []
    fail_list = []

    for system_name, problems in benchmark_info.items():
        for problem_name in problems.keys():
            try:
                ok = extract_ref_ppa(problem_name, system_name, synthesis_evaluator)
                if ok:
                    success_list.append(problem_name)
                else:
                    fail_list.append(problem_name)
            except Exception as e:
                print(f"[ERROR] {problem_name}: {e}")
                fail_list.append(problem_name)

    print("\n========== 완료 ==========")
    print(f"성공: {len(success_list)}개 → {success_list}")
    print(f"실패: {len(fail_list)}개 → {fail_list}")


if __name__ == "__main__":
    main()