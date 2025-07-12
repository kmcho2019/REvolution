module freq_divbyfrac (
    input  clk,
    input  rst_n,
    output clk_div
);

// Define parameters for fractional division
parameter MUL2_DIV_CLK = 7; // 3.5x division
parameter LONG_CLK_CYC = 4; // Longer clock period
parameter SHORT_CLK_CYC = 3; // Shorter clock period

// Define internal signals
reg [2:0] cnt; // Counter to cycle through 7 clock cycles
reg clk_long; // Longer clock period signal
reg clk_short; // Shorter clock period signal
reg clk_long_dly; // Delayed longer clock period signal
reg clk_short_adv; // Advanced shorter clock period signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

// Generate longer and shorter clock periods
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_long <= 0;
        clk_short <= 0;
    end else begin
        if (cnt == LONG_CLK_CYC - 1) begin
            clk_long <= 1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_long <= 0;
        end
        
        if (cnt == SHORT_CLK_CYC - 1) begin
            clk_short <= 1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_short <= 0;
        end
    end
end

// Generate phase-shifted clocks using double-edge clocking
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_long_dly <= 0;
        clk_short_adv <= 0;
    end else begin
        if (cnt == LONG_CLK_CYC - 1) begin
            clk_long_dly <= 1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_long_dly <= 0;
        end
        
        if (cnt == SHORT_CLK_CYC - 2) begin
            clk_short_adv <= 1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_short_adv <= 0;
        end
    end
end

// Logically OR the phase-shifted clocks to produce the final fractional divided clock output
assign clk_div = clk_long | clk_short_adv;

endmodule