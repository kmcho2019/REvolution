module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire gated_clk;

// Clock gating for reset
assign gated_clk = clk & ~r;

// D flip-flop with gated clock
always @(posedge gated_clk) begin
    q <= d;
end

// Combinational reset path
always @(*) begin
    if (r) q = 1'b0;
end

endmodule