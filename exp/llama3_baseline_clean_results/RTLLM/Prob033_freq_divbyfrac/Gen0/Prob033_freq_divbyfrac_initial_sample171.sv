module freq_divbyfrac(
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Define the parameters for 3.5x division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for division
localparam HIGH_CNT = 4;     // High period of divided clock
localparam LOW_CNT = 3;      // Low period of divided clock

reg [2:0] cnt; // Counter to track clock cycles
reg clk_div_int; // Intermediate divided clock signal
reg clk_div_int_dly; // Delayed version of intermediate divided clock
reg clk_div_int_adv; // Advanced version of intermediate divided clock

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0; // Reset counter
        clk_div_int <= 1'b0; // Reset intermediate clock
        clk_div_int_dly <= 1'b0; // Reset delayed intermediate clock
        clk_div_int_adv <= 1'b0; // Reset advanced intermediate clock
    end else begin
        // Count clock cycles
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b0; // Reset counter
        end else begin
            cnt <= cnt + 1'b1; // Increment counter
        end
        
        // Generate intermediate divided clock
        if (cnt < HIGH_CNT) begin
            clk_div_int <= 1'b1; // Set intermediate clock high
        end else begin
            clk_div_int <= 1'b0; // Set intermediate clock low
        end
        
        // Phase-shift intermediate clocks
        if (cnt == 1) begin
            clk_div_int_dly <= 1'b1; // Set delayed intermediate clock high
        end else if (cnt == LOW_CNT + 1) begin
            clk_div_int_dly <= 1'b0; // Set delayed intermediate clock low
        end
        
        if (cnt == HIGH_CNT - 1) begin
            clk_div_int_adv <= 1'b1; // Set advanced intermediate clock high
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_int_adv <= 1'b0; // Set advanced intermediate clock low
        end
    end
end

// Logically OR phase-shifted clocks to produce final divided clock
assign clk_div = clk_div_int | clk_div_int_dly | clk_div_int_adv;

endmodule