module freq_divbyfrac(
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Define the parameters for the desired fractional division
parameter MUL2_DIV_CLK = 7;  // For 3.5x division

// Define the counter to track clock cycles
reg [2:0] counter;

// Define the intermediate divided clock signals
reg clk_div_int1;
reg clk_div_int2;

// Define the D flip-flops for generating phase-shifted clocks
reg clk_div_dff1;
reg clk_div_dff2;

// Initialize the counter and divided clock signals
initial begin
    counter = 0;
    clk_div_int1 = 0;
    clk_div_int2 = 0;
    clk_div_dff1 = 0;
    clk_div_dff2 = 0;
end

// Generate the intermediate divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div_int1 <= 0;
        clk_div_int2 <= 0;
    end else begin
        // Count the clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
        
        // Generate uneven clock periods (4 source clock cycles and 3 source clock cycles)
        if (counter < 4) begin
            clk_div_int1 <= 1;
        end else begin
            clk_div_int1 <= 0;
        end
        
        if (counter < 3) begin
            clk_div_int2 <= 1;
        end else begin
            clk_div_int2 <= 0;
        end
    end
end

// Generate phase-shifted versions of the divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_dff1 <= 0;
        clk_div_dff2 <= 0;
    end else begin
        // Delay one phase by half a clock period
        clk_div_dff1 <= clk_div_int1;
        
        // Advance the other phase by half a clock period (using the falling edge)
        if (counter == 3) begin
            clk_div_dff2 <= 1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_dff2 <= 0;
        end
    end
end

// Logically OR the two intermediate clocks to produce the final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else begin
        // OR the phase-shifted clocks
        clk_div <= clk_div_dff1 | clk_div_dff2;
    end
end

endmodule