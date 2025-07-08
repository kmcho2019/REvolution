module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

localparam integer MUL2_DIV_CLK = 7;

// Counter for clock cycles (0 to 6)
reg [2:0] cnt;

//
// Two intermediate divided clocks:
// clk_div_r: updated on clk rising edge
// clk_div_f: updated on clk falling edge (phase shifted by half period)
//
reg clk_div_r;
reg clk_div_f;

// Counter increments on rising edge of clk
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'd0;
        clk_div_r <= 1'b0;
    end else begin
        if (cnt == (MUL2_DIV_CLK - 1))
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;

        // Generate clk_div_r with high for 4 cycles, low for 3 cycles
        // High when cnt is 0,1,2,3 -> 4 cycles high
        if (cnt < 4)
            clk_div_r <= 1'b1;
        else
            clk_div_r <= 1'b0;
    end
end

// Generate clk_div_f on falling edge of clk, delayed by half period
// Use a counter that tracks the cnt value at falling edge (delayed by half clock)
// This signal has high for 3 cycles and low for 4 cycles (inverse pattern)
// i.e., high when cnt is 3,4,5 (3 cycles high)
reg [2:0] cnt_f;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_f <= 3'd0;
        clk_div_f <= 1'b0;
    end else begin
        if (cnt_f == (MUL2_DIV_CLK - 1))
            cnt_f <= 3'd0;
        else
            cnt_f <= cnt_f + 3'd1;

        // High for cnt_f == 3,4,5 (3 cycles high)
        if ((cnt_f >= 3) && (cnt_f <= 5))
            clk_div_f <= 1'b1;
        else
            clk_div_f <= 1'b0;
    end
end

// Final fractional divided clock is OR of two intermediate signals
assign clk_div = clk_div_r | clk_div_f;

endmodule