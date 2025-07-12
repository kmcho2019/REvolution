module freq_divbyfrac (
    input  wire        clk,       // Input clock signal
    input  wire        rst_n,     // Active low reset signal
    output reg          clk_div   // Fractionally divided clock output
);

// Counter to cycle through 7 clock cycles
reg [2:0] counter;

// Intermediate divided clock signals with uneven periods
reg       clk_div_4;
reg       clk_div_3;
reg       clk_div_4_delayed;
reg       clk_div_3_advanced;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize the counter and clock signals on reset
        counter     <= 3'b000;
        clk_div_4   <= 1'b0;
        clk_div_3   <= 1'b0;
        clk_div_4_delayed <= 1'b0;
        clk_div_3_advanced <= 1'b0;
    end else begin
        // Increment the counter
        counter <= counter + 1;
        
        // Generate intermediate divided clock signals
        if (counter == 3'b100) begin
            // Every 4th clock cycle, set clk_div_4 high for one cycle
            clk_div_4 <= 1'b1;
        end else if (counter == 3'b101) begin
            // Clear clk_div_4 after one cycle
            clk_div_4 <= 1'b0;
        end
        
        if (counter == 3'b011) begin
            // Every 3rd clock cycle, set clk_div_3 high for one cycle
            clk_div_3 <= 1'b1;
        end else if (counter == 3'b100) begin
            // Clear clk_div_3 after one cycle
            clk_div_3 <= 1'b0;
        end
        
        // Phase-shift the intermediate clocks by half a clock period
        if (clk_div_4) begin
            // Delay clk_div_4 by half a clock period
            clk_div_4_delayed <= ~clk;
        end else begin
            clk_div_4_delayed <= 1'b0;
        end
        
        if (clk_div_3) begin
            // Advance clk_div_3 by half a clock period
            clk_div_3_advanced <= ~clk;
        end else begin
            clk_div_3_advanced <= 1'b0;
        end
        
        // Generate the final fractional divided clock output
        clk_div <= (clk_div_4 | clk_div_4_delayed | clk_div_3 | clk_div_3_advanced);
        
        // Reset the counter after 7 clock cycles
        if (counter == 3'b110) begin
            counter <= 3'b000;
        end
    end
end

endmodule