module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

// Parameters
localparam integer MUL2_DIV_CLK = 7; // 3.5 * 2

// Counter for posedge clk domain (0..6)
reg [2:0] cnt_pos;
// Counter for negedge clk domain (0..6)
reg [2:0] cnt_neg;

// Divided clocks toggling at uneven intervals
reg clk_even;  // toggles every 4 posedge clk cycles (counts 0..3)
reg clk_odd;   // toggles every 3 negedge clk cycles (counts 0..2)

// Posedge clk domain: increment counter and toggle clk_even every 4 counts
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 3'd0;
        clk_even <= 1'b0;
    end else begin
        if (cnt_pos == (MUL2_DIV_CLK - 1))
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;

        if (cnt_pos == 3'd3)  // toggle every 4 cycles
            clk_even <= ~clk_even;
    end
end

// Negedge clk domain: increment counter and toggle clk_odd every 3 counts
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 3'd0;
        clk_odd <= 1'b0;
    end else begin
        if (cnt_neg == (MUL2_DIV_CLK - 1))
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;

        if (cnt_neg == 3'd2)  // toggle every 3 cycles
            clk_odd <= ~clk_odd;
    end
end

// Final output is OR of clk_even and clk_odd, producing a fractional divided clock
assign clk_div = clk_even | clk_odd;

endmodule