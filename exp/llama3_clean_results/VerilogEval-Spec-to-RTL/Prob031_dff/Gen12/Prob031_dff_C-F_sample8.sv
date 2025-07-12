module TopModule(
    input clk,
    input d,
    output reg q
);
// Synthesis directive for area optimization (example, actual directive may vary based on synthesis tool)
// $area_optimization_directive
always_ff @(posedge clk) q <= d;
endmodule