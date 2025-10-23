module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional frequency divider
localparam MUL2_DIV_CLK = 7;  // Multiplication factor for 3.5x division
localparam DIV_CLK_HALF = MUL2_DIV_CLK / 2;  // Half of the multiplication factor

// Signals for the counter
reg [2:0] cnt;  // Counter for generating intermediate clocks

// Signals for the intermediate clocks
reg clk_div_4;  // Intermediate clock signal for 4 cycles
reg clk_div_3;  // Intermediate clock signal for 3 cycles

// Signals for the phase-shifted clocks
reg clk_div_4_ps;  // Phase-shifted clock signal for 4 cycles
reg clk_div_3_ps;  // Phase-shifted clock signal for 3 cycles

// Initialize the counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_4 <= 0;
        clk_div_3 <= 0;
    end else begin
        if (cnt < MUL2_DIV_CLK) begin
            cnt <= cnt + 1;
            if (cnt < DIV_CLK_HALF) begin
                clk_div_4 <= 1;
            end else begin
                clk_div_4 <= 0;
            end
            if (cnt < DIV_CLK_HALF - 1) begin
                clk_div_3 <= 1;
            end else begin
                clk_div_3 <= 0;
            end
        end else begin
            cnt <= 0;
        end
    end
end

// Phase-shift the intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4_ps <= 0;
        clk_div_3_ps <= 0;
    end else begin
        clk_div_4_ps <= clk_div_4;
        #1;
        clk_div_3_ps <= ~clk_div_3;
    end
end

// Generate the final divided clock signal
assign clk_div = clk_div_4_ps | clk_div_3_ps;

endmodule