module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the parameters for the fractional frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_CYCLES_1 = 4; // Clock cycles for the first divided clock period
parameter DIV_CLK_CYCLES_2 = 3; // Clock cycles for the second divided clock period

// Internal signals
reg [2:0] counter; // Counter for clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg clk_div_int1_shifted; // Phase-shifted intermediate divided clock signal 1
reg clk_div_int2_shifted; // Phase-shifted intermediate divided clock signal 2

// Initialize the counter and divided clock signals on reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div_int1 <= 0;
        clk_div_int2 <= 0;
        clk_div_int1_shifted <= 0;
        clk_div_int2_shifted <= 0;
    end else begin
        // Count the clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        
        // Generate the intermediate divided clock signals
        if (counter < DIV_CLK_CYCLES_1) begin
            clk_div_int1 <= 1;
        end else begin
            clk_div_int1 <= 0;
        end
        
        if ((counter >= DIV_CLK_CYCLES_1) && (counter < MUL2_DIV_CLK)) begin
            clk_div_int2 <= 1;
        end else begin
            clk_div_int2 <= 0;
        end
        
        // Generate the phase-shifted intermediate divided clock signals
        clk_div_int1_shifted <= clk_div_int1;
        clk_div_int2_shifted <= clk_div_int2;
    end
end

// Generate the phase-shifted clocks using the double-edge clocking technique
always @(posedge clk) begin
    clk_div_int1_shifted <= ~clk_div_int1;
end

always @(negedge clk) begin
    clk_div_int2_shifted <= ~clk_div_int2;
end

// Logically OR the phase-shifted clocks to produce the final fractional divided clock output
assign clk_div = clk_div_int1_shifted | clk_div_int2_shifted;

endmodule