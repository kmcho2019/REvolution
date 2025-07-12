module freq_divbyfrac(
    input  clk,       // Input clock signal
    input  rst_n,     // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Define constants for fractional division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total cycles for division

// Internal signals
reg [2:0] counter; // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock 1 (4 cycles)
reg clk_div_int2;  // Intermediate divided clock 2 (3 cycles)
reg clk_div_int1_delay; // Delayed intermediate clock 1
reg clk_div_int2_advance; // Advanced intermediate clock 2

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal signals
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delay <= 1'b0;
        clk_div_int2_advance <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter
        counter <= counter + 1'b1;
        
        // Generate intermediate divided clocks
        if (counter == 3'b100) begin // 4 cycles
            clk_div_int1 <= 1'b1;
        end else if (counter == 3'b011) begin // 3 cycles
            clk_div_int2 <= 1'b1;
        end
        
        // Reset intermediate clocks
        if (counter == 3'b110) begin
            clk_div_int1 <= 1'b0;
        end else if (counter == 3'b101) begin
            clk_div_int2 <= 1'b0;
        end
        
        // Generate phase-shifted clocks
        clk_div_int1_delay <= clk_div_int1;
        clk_div_int2_advance <= clk_div_int2;
        
        // Final fractional divided clock output
        clk_div <= clk_div_int1 | clk_div_int2 | clk_div_int1_delay | clk_div_int2_advance;
        
        // Reset counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end
    end
end

endmodule