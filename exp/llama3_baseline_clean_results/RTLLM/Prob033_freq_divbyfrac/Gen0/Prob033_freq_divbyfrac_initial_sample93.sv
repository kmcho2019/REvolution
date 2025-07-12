module freq_divbyfrac (
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7;  // Counter cycles through 7 clock cycles for 3.5x division
localparam HIGH_COUNT = 4;   // Higher count for uneven clock period
localparam LOW_COUNT = 3;    // Lower count for uneven clock period

reg [2:0] counter;  // Counter to track the clock cycles
reg clk_int_high;  // Intermediate clock with higher period
reg clk_int_low;   // Intermediate clock with lower period
reg clk_int_high_phase;  // Phase-shifted intermediate clock with higher period
reg clk_int_low_phase;   // Phase-shifted intermediate clock with lower period

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;  // Reset counter
        clk_int_high <= 1'b0;
        clk_int_low <= 1'b0;
        clk_int_high_phase <= 1'b0;
        clk_int_low_phase <= 1'b0;
    end else begin
        // Increment counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Generate intermediate clocks
        if (counter < HIGH_COUNT) begin
            clk_int_high <= (counter == HIGH_COUNT - 1) ? 1'b1 : 1'b0;
        end else begin
            clk_int_high <= (counter == MUL2_DIV_CLK - 1) ? 1'b0 : 1'b0;
        end
        
        if (counter >= HIGH_COUNT) begin
            clk_int_low <= (counter == MUL2_DIV_CLK - 1) ? 1'b1 : 1'b0;
        end else begin
            clk_int_low <= 1'b0;
        end
        
        // Phase-shift intermediate clocks
        clk_int_high_phase <= clk_int_high;
        clk_int_low_phase <= clk_int_low;
        
        // Generate final clock output by logically OR-ing phase-shifted clocks
        if (counter == HIGH_COUNT - 1) begin
            clk_div <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div <= 1'b0;
        end else begin
            clk_div <= (clk_int_high_phase | clk_int_low_phase);
        end
    end
end

endmodule