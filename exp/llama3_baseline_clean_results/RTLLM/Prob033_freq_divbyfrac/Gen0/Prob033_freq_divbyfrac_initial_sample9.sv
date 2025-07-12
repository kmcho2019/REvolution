module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,    // Active low reset signal
    output clk_div  // Fractionally divided clock output
);

// Define the constants for fractional frequency division (3.5x)
localparam MUL2_DIV_CLK = 7;  // Total clock cycles for the division
localparam DIV_CLK_HIGH = 4;  // Number of clock cycles for the high period
localparam DIV_CLK_LOW = 3;   // Number of clock cycles for the low period

// Internal counters and signals
reg [2:0] counter;  // Counter to keep track of the clock cycles
reg clk_div_int;   // Intermediate divided clock signal
reg clk_div_int_shifted;  // Phase-shifted intermediate divided clock signal
reg half_clk;      // Half clock period signal for phase-shifting

// Sequential logic to generate the intermediate divided clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;  // Reset the counter
        clk_div_int <= 1'b0;  // Reset the intermediate divided clock
        clk_div_int_shifted <= 1'b0;  // Reset the phase-shifted intermediate divided clock
    end else begin
        // Count the clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;  // Reset the counter
        end else begin
            counter <= counter + 1;  // Increment the counter
        end

        // Generate the intermediate divided clock signal
        if (counter < DIV_CLK_HIGH) begin
            clk_div_int <= 1'b1;  // High period
        end else begin
            clk_div_int <= 1'b0;  // Low period
        end

        // Generate the phase-shifted intermediate divided clock signal
        if (counter < DIV_CLK_LOW) begin
            clk_div_int_shifted <= 1'b1;  // High period (phase-shifted)
        end else begin
            clk_div_int_shifted <= 1'b0;  // Low period (phase-shifted)
        end
    end
end

// Generate the half clock period signal for phase-shifting
always @(posedge clk) begin
    half_clk <= ~half_clk;  // Toggle the half clock period signal
end

// Generate the final fractional divided clock output
assign clk_div = clk_div_int | (clk_div_int_shifted ^ half_clk);

endmodule