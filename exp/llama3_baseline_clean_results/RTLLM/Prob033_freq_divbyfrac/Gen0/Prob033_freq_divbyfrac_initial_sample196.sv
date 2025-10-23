module freq_divbyfrac(
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output clk_div // Fractionally divided clock output
);

// Parameters for 3.5x division
localparam MUL2_DIV_CLK = 7; // 7 clock cycles for 3.5x division
localparam DIV CLK_HALF_CYCLE = MUL2_DIV_CLK / 2; // Half of the division clock cycles

reg [2:0] counter; // Counter to generate intermediate divided clock
reg clk_div_int;  // Intermediate divided clock signal
reg clk_div_delayed; // Delayed version of the intermediate divided clock
reg clk_div_advanced; // Advanced version of the intermediate divided clock

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_int <= 1'b0; // Reset intermediate clock
        clk_div_delayed <= 1'b0; // Reset delayed clock
        clk_div_advanced <= 1'b0; // Reset advanced clock
    end else begin
        // Count clock cycles to generate intermediate divided clock
        if (counter == 3'b100) begin // 4 source clock cycles
            counter <= 3'b000; // Reset counter
            clk_div_int <= ~clk_div_int; // Toggle intermediate clock
        end else begin
            counter <= counter + 1'b1; // Increment counter
        end
        
        // Generate delayed and advanced versions of the intermediate clock
        if (counter == 3'b001) begin // First clock cycle
            clk_div_delayed <= clk_div_int; // Delayed clock
        end
        
        if (counter == 3'b011) begin // Third clock cycle
            clk_div_advanced <= clk_div_int; // Advanced clock
        end
    end
end

// Logically OR the delayed and advanced clocks to produce the final fractional divided clock output
assign clk_div = clk_div_delayed | clk_div_advanced;

endmodule