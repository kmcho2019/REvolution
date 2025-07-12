module TopModule (
    input clk,
    input d,
    output reg q
);

wire clk_inv;
reg ff_pos;
reg ff_neg;

// Invert clock
assign clk_inv = ~clk;

// Flip-flop triggered on posedge clk
always @(posedge clk) begin
    ff_pos <= d;
end

// Flip-flop triggered on posedge of inverted clock (i.e., negedge clk)
always @(posedge clk_inv) begin
    ff_neg <= d;
end

// Combine both sampled values; q updates on both edges
always @(*) begin
    q = ff_pos | ff_neg;
end

endmodule