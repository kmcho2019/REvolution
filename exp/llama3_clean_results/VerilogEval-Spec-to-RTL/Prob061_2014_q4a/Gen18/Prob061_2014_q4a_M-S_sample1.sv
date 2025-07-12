module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk)
    Q <= L ? R : E ? w : Q;

endmodule