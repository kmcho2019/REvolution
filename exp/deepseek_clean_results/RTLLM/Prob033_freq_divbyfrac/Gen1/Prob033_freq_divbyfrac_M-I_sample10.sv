module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters
parameter DIV_RATIO = 7;  // 3.5 * 2 = 7

// Internal signals
reg [2:0] counter;
reg clk_pos, clk_neg;
wire clk_neg_sync;

// Main counter (runs at input clock rate)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == DIV_RATIO - 1) ? 3'b0 : counter + 1;
    end
end

// Positive edge generated clock (4 high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_pos <= 1'b0;
    end else begin
        clk_pos <= (counter < 4);
    end
end

// Negative edge generated clock (3 high, 4 low)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 1'b0;
    end else begin
        clk_neg <= (counter < 3);
    end
end

// Synchronize negative edge clock to positive edge
FDRE #(.INIT(1'b0)) sync_ff (
    .C(clk),
    .CE(1'b1),
    .D(clk_neg),
    .Q(clk_neg_sync),
    .R(~rst_n)
);

// Combine the clocks to get final output
assign clk_div = clk_pos | clk_neg_sync;

endmodule