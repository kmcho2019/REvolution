module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants for fractional division
parameter MUL2_DIV_CLK = 7; // Counter cycles through 7 clock cycles for 3.5x division

// Internal signals
reg [2:0] counter; // Counter to track input clock cycles
reg clk_div_int1; // Intermediate divided clock 1
reg clk_div_int2; // Intermediate divided clock 2, phase-shifted
reg clk_div_int1_dly; // Delayed version of clk_div_int1 for OR-ing

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter to 0
        clk_div_int1 <= 1'b0; // Reset intermediate clock 1 to 0
        clk_div_int2 <= 1'b0; // Reset intermediate clock 2 to 0
        clk_div_int1_dly <= 1'b0; // Reset delayed intermediate clock 1 to 0
        clk_div <= 1'b0; // Reset final divided clock to 0
    end else begin
        // Increment counter on every clock edge
        counter <= counter + 1'b1;
        
        // Generate intermediate divided clock 1 (4 source clock cycles)
        if (counter == 3'b100) begin // 4th clock cycle
            clk_div_int1 <= 1'b1;
        end else if (counter == 3'b111) begin // 7th clock cycle, reset clk_div_int1
            clk_div_int1 <= 1'b0;
        end
        
        // Generate intermediate divided clock 2, phase-shifted (3 source clock cycles)
        if (counter == 3'b011) begin // 3rd clock cycle, delayed by half a clock period
            clk_div_int2 <= 1'b1;
        end else if (counter == 3'b101) begin // 5th clock cycle, advanced by half a clock period
            clk_div_int2 <= 1'b1;
        end else if (counter == 3'b110) begin // 6th clock cycle, reset clk_div_int2
            clk_div_int2 <= 1'b0;
        end
        
        // Delay intermediate clock 1 by half a clock period for OR-ing
        clk_div_int1_dly <= clk_div_int1;
        
        // Generate final divided clock output by logically OR-ing intermediate clocks
        clk_div <= clk_div_int1 || clk_div_int2 || clk_div_int1_dly;
    end
end

endmodule