module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk;
reg enable;

// Clock gating logic
assign gated_clk = clk & (E | L);

// Combined control and storage logic
always @(posedge gated_clk) begin
    if (L)
        Q <= R;
    else if (E)
        Q <= w;
    // else retain value (implicit)
end

endmodule