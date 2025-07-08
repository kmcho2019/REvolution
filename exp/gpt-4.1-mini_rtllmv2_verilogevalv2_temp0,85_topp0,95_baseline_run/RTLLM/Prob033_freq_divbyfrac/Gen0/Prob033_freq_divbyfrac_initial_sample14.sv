module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

localparam integer MUL2_DIV_CLK = 7; // 2 * division factor (3.5 * 2)

reg [2:0] cnt_rising;  // Counter for clk rising edge domain
reg [2:0] cnt_falling; // Counter for clk falling edge domain

reg clk_rising;  // Intermediate clock triggered on clk rising edge
reg clk_falling; // Intermediate clock triggered on clk falling edge

// Counters and intermediate clock generation on rising edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_rising <= 3'd0;
        clk_rising <= 1'b0;
    end else begin
        if (cnt_rising == MUL2_DIV_CLK - 1)
            cnt_rising <= 3'd0;
        else
            cnt_rising <= cnt_rising + 3'd1;

        // clk_rising high for first 4 counts, low for next 3 counts => period 7
        if (cnt_rising < 4)
            clk_rising <= 1'b1;
        else
            clk_rising <= 1'b0;
    end
end

// Counters and intermediate clock generation on falling edge (phase shifted by half clk)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_falling <= 3'd0;
        clk_falling <= 1'b0;
    end else begin
        if (cnt_falling == MUL2_DIV_CLK - 1)
            cnt_falling <= 3'd0;
        else
            cnt_falling <= cnt_falling + 3'd1;

        // clk_falling high for first 3 counts, low for next 4 counts (complement to rising edge)
        // This shifts the high period to compensate for duty cycle imbalance
        if (cnt_falling < 3)
            clk_falling <= 1'b1;
        else
            clk_falling <= 1'b0;
    end
end

// Final fractional divided clock by OR-ing the two intermediate clocks
assign clk_div = clk_rising | clk_falling;

endmodule