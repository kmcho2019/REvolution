module freq_divbyfrac(
    input  clk,       // Input clock signal
    input  rst_n,     // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Define constants for the fractional division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
localparam DIVIDER_LONG = 4; // Longer clock period
localparam DIVIDER_SHORT = 3; // Shorter clock period

// Internal signals
reg [2:0] cnt; // Counter to track clock cycles
reg clk_int_long; // Intermediate long clock
reg clk_int_short; // Intermediate short clock
reg clk_int_long_dly; // Delayed long clock for phase-shifting
reg clk_int_short_adv; // Advanced short clock for phase-shifting

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000; // Reset counter
        clk_int_long <= 1'b0;
        clk_int_short <= 1'b0;
    end else begin
        cnt <= cnt + 1'b1;
        if (cnt == DIVIDER_LONG) begin
            clk_int_long <= 1'b1;
        end else if (cnt == (MUL2_DIV_CLK - 1)) begin
            clk_int_long <= 1'b0;
        end
        if (cnt == (MUL2_DIV_CLK - DIVIDER_SHORT)) begin
            clk_int_short <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_int_short <= 1'b0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk) begin
    clk_int_long_dly <= clk_int_long;
    clk_int_short_adv <= clk_int_short;
end

// Final clock output logic
always @(posedge clk) begin
    if (clk_int_long_dly || clk_int_short_adv) begin
        clk_div <= 1'b1;
    end else begin
        clk_div <= 1'b0;
    end
end

endmodule