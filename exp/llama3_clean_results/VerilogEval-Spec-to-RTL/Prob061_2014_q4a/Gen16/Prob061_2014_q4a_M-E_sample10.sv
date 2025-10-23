module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg mux_out;

always @(posedge clk) begin
    mux_out <= L? R : w;
    Q <= E? mux_out : Q;
end

endmodule