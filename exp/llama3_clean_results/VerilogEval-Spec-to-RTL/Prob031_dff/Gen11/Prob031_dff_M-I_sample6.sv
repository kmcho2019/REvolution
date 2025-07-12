module TopModule(
    input clk,
    input d,
    output reg q
);
always_ff @(posedge clk) q <= d;
// Synthesis directive for area optimization (example, actual directive may vary based on synthesis tool)
// $area_optimization_directive
endmodule