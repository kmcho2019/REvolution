module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Clock gating: Generate a gated clock that is only active when an operation is enabled
wire gated_clk;
assign gated_clk = clk & (E | L);

always @(posedge gated_clk) begin
    if (L) begin
        Q <= R;
    end else if (E) begin
        Q <= w;
    end
end

endmodule