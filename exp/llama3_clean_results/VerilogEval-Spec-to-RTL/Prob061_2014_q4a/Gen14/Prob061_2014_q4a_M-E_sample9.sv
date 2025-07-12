module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    reg tmp;
    // First multiplexer: Select between w and R based on L
    tmp = (L) ? R : w;
    // Second multiplexer: Select between tmp and Q based on E
    Q <= (E) ? tmp : Q;
end

endmodule