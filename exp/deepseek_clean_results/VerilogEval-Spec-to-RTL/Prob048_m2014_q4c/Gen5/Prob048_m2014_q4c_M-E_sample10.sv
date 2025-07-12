module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire gated_clk;
reg next_q;

// Clock gating logic
assign gated_clk = clk & ~r;

// Data path
always @(*) begin
    if (r)
        next_q = 1'b0;
    else
        next_q = d;
end

// Flip-flop with gated clock
always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule