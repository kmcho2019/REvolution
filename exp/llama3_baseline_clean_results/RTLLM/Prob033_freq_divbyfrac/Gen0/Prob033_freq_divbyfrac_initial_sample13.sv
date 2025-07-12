module freq_divbyfrac (
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for frequency division (3.5x)
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for division

// Internal signals
reg [2:0] counter;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock signal 1 (4 clock cycles)
reg clk_div_int2;  // Intermediate divided clock signal 2 (3 clock cycles)
reg clk_div_int1_p;  // Phase-shifted intermediate divided clock signal 1 (delayed by half a clock period)
reg clk_div_int2_n;  // Phase-shifted intermediate divided clock signal 2 (advanced by half a clock period)

// Counter to track clock cycles
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;  // Reset counter
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;  // Reset counter when it reaches the maximum value
        end else begin
            counter <= counter + 1;  // Increment counter
        end
    end
end

// Generate intermediate divided clock signals with uneven clock periods
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1 <= 1'b0;  // Reset intermediate divided clock signal 1
        clk_div_int2 <= 1'b0;  // Reset intermediate divided clock signal 2
    end else begin
        if (counter == 3'b100) begin  // 4 clock cycles
            clk_div_int1 <= ~clk_div_int1;  // Toggle intermediate divided clock signal 1
        end
        if (counter == 3'b011) begin  // 3 clock cycles
            clk_div_int2 <= ~clk_div_int2;  // Toggle intermediate divided clock signal 2
        end
    end
end

// Phase-shift intermediate clocks by half a clock period
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1_p <= 1'b0;  // Reset phase-shifted intermediate divided clock signal 1 (delayed by half a clock period)
        clk_div_int2_n <= 1'b0;  // Reset phase-shifted intermediate divided clock signal 2 (advanced by half a clock period)
    end else begin
        clk_div_int1_p <= clk_div_int1;  // Delay intermediate divided clock signal 1 by half a clock period
        clk_div_int2_n <= clk_div_int2;  // Advance intermediate divided clock signal 2 by half a clock period
    end
end

// Logically OR phase-shifted clocks to produce final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;  // Reset final fractional divided clock output
    end else begin
        clk_div <= clk_div_int1_p | clk_div_int2_n;  // Logically OR phase-shifted intermediate clocks
    end
end

endmodule