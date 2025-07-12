module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x frequency division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for division
localparam DIV_CLK_LONG = 4; // Longer uneven clock cycle count
localparam DIV_CLK_SHORT = 3; // Shorter uneven clock cycle count

// Internal signals
reg [2:0] cnt; // Counter for clock cycles
reg clk_div_long; // Longer divided clock signal
reg clk_div_short; // Shorter divided clock signal
reg clk_div_long_dly; // Delayed longer divided clock signal
reg clk_div_short_adv; // Advanced shorter divided clock signal

// Counter to generate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_long <= 1'b0;
        clk_div_short <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate longer divided clock signal
        if (cnt == DIV_CLK_LONG - 1) begin
            clk_div_long <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_long <= 1'b0;
        end
        
        // Generate shorter divided clock signal
        if (cnt == DIV_CLK_SHORT - 1) begin
            clk_div_short <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_short <= 1'b0;
        end
    end
end

// Delay and advance divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_long_dly <= 1'b0;
        clk_div_short_adv <= 1'b0;
    end else begin
        // Delay longer divided clock signal by half clock period
        if (clk_div_long) begin
            clk_div_long_dly <= ~clk_div_long;
        end else begin
            clk_div_long_dly <= 1'b0;
        end
        
        // Advance shorter divided clock signal by half clock period
        if (clk_div_short) begin
            clk_div_short_adv <= ~clk_div_short;
        end else begin
            clk_div_short_adv <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the phase-shifted clocks
        clk_div <= clk_div_long_dly | clk_div_short_adv;
    end
end

endmodule