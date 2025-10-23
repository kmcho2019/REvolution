module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q = 1'b0
);

wire gated_clk;
reg  d_changed;

// Detect when we need to update (reset or data change)
always @(*) begin
    d_changed = (d != q) || r;
end

// Create gated clock
assign gated_clk = clk & d_changed;

// Gated clock flip-flop
always @(posedge gated_clk) begin
    if (r) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule