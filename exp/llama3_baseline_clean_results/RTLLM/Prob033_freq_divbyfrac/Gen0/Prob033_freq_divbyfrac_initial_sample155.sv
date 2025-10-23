module freq_divbyfrac(
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional division
parameter MUL2_DIV_CLK = 7; // 3.5x division factor

// Counter to track the clock cycles
reg [2:0] cnt;

// Intermediate divided clock signals
reg clk_div_long; // 4 source clock cycles
reg clk_div_short; // 3 source clock cycles

// Phase-shifted versions of the divided clock
reg clk_div_long_shifted;
reg clk_div_short_shifted;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and clock signals
        cnt <= 3'b000;
        clk_div_long <= 1'b0;
        clk_div_short <= 1'b0;
        clk_div_long_shifted <= 1'b0;
        clk_div_short_shifted <= 1'b0;
    end else begin
        // Increment the counter
        cnt <= cnt + 1'b1;
        
        // Generate the intermediate divided clock signals
        if (cnt == 3'b100) begin // 4 source clock cycles
            clk_div_long <= 1'b1;
        end else if (cnt == 3'b011) begin // 3 source clock cycles
            clk_div_short <= 1'b1;
        end
        
        // Reset the intermediate divided clock signals
        if (cnt == 3'b110) begin
            clk_div_long <= 1'b0;
        end else if (cnt == 3'b101) begin
            clk_div_short <= 1'b0;
        end
        
        // Apply the double-edge clocking technique
        // Delay one phase by half a clock period and advance the other phase by half a clock period
        if (cnt == 3'b001) begin
            clk_div_long_shifted <= ~clk_div_long;
        end else if (cnt == 3'b010) begin
            clk_div_short_shifted <= ~clk_div_short;
        end
        
        // Logically OR the two intermediate clocks to produce the final fractional divided clock output
        clk_div <= clk_div_long | clk_div_short | clk_div_long_shifted | clk_div_short_shifted;
    end
end

endmodule