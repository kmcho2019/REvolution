module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire mux_out;

assign mux_out = L ? R : (E ? w : Q);

always @(posedge clk)
    Q <= mux_out;

endmodule