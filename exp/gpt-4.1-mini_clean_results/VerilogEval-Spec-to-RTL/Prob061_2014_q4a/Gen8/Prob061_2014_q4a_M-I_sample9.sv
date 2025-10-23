module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    wire gated_clk = clk & (L | E);

    always @(posedge gated_clk) begin
        Q <= L ? R : w;
    end

endmodule