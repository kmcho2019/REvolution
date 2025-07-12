module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire clock_enable = L || E;
wire gated_clk = clk & clock_enable;
wire next_Q = L ? R : (E ? w : Q);

always @(posedge gated_clk) begin
    Q <= next_Q;
end

endmodule