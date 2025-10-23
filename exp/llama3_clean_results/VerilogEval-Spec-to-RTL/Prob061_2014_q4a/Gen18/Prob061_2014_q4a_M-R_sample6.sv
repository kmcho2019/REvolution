// Refactored solution
module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg next_Q;

assign next_Q = L ? R : (E ? w : Q);

always @(posedge clk) 
    Q <= next_Q;

endmodule