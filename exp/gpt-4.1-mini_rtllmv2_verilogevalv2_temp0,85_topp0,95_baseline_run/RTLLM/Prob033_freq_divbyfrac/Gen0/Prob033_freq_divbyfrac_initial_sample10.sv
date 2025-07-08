module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

localparam MUL2_DIV_CLK = 7;  // double multiplication factor for 3.5 division

reg [2:0] cnt;            // 3 bits counter for 0 to 6
reg       div_clk_rise;   // divided clock from positive edge domain
reg       div_clk_fall;   // divided clock from negative edge domain

// Counter running on rising edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'd0;
    end else begin
        if (cnt == (MUL2_DIV_CLK-1))
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end
end

// Generate divided clock on rising edge domain
// Logic: high for 4 cycles, low for 3 cycles => toggle on cnt==3 (end of 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        div_clk_rise <= 1'b0;
    else if (cnt == 3'd3)  // toggle after 4 cycles (0,1,2,3)
        div_clk_rise <= ~div_clk_rise;
end

// Generate divided clock on falling edge domain
// To create the half-cycle phase shift, use falling edge clock and similar toggling logic shifted by 1 cycle
reg [2:0] cnt_fall;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_fall <= 3'd0;
    end else begin
        if (cnt_fall == (MUL2_DIV_CLK-1))
            cnt_fall <= 3'd0;
        else
            cnt_fall <= cnt_fall + 3'd1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        div_clk_fall <= 1'b0;
    else if (cnt_fall == 3'd3)  // toggle after 4 cycles on falling edge domain
        div_clk_fall <= ~div_clk_fall;
end

// Final fractional divided clock is OR of the two phase shifted clocks
assign clk_div = div_clk_rise | div_clk_fall;

endmodule