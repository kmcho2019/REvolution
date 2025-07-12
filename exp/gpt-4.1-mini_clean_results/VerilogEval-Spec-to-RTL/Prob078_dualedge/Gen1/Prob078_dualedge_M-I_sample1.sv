module TopModule (
    input  clk,
    input  d,
    output reg q
);

wire clk_inv;
reg ff_pos;
reg ff_neg;

// Invert clock to create negedge clk trigger
assign clk_inv = ~clk;

// Sample input d on posedge clk
always @(posedge clk) begin
    ff_pos <= d;
end

// Sample input d on negedge clk via posedge clk_inv
always @(posedge clk_inv) begin
    ff_neg <= d;
end

// Toggle q whenever ff_pos and ff_neg differ (input d changed on either edge)
always @(posedge clk) begin
    q <= q ^ (ff_pos ^ ff_neg);
end

endmodule