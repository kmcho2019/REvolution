module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter MUL2_DIV_CLK = 7; // Multiplier for fractional division
parameter CLK_HIGH_CYCLES = 4; // Number of clock cycles for high period
parameter CLK_LOW_CYCLES = 3; // Number of clock cycles for low period

reg [2:0] counter; // Counter to generate divided clock signal
reg clk_div_int; // Intermediate divided clock signal
reg clk_div_int_shifted; // Phase-shifted intermediate divided clock signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
        clk_div_int <= 1'b0; // Reset intermediate clock signal
        clk_div_int_shifted <= 1'b0; // Reset phase-shifted intermediate clock signal
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000; // Reset counter
            clk_div_int <= ~clk_div_int; // Toggle intermediate clock signal
            if (clk_div_int) begin
                clk_div_int_shifted <= 1'b1; // Set phase-shifted intermediate clock signal high
            end else begin
                clk_div_int_shifted <= 1'b0; // Set phase-shifted intermediate clock signal low
            end
        end else begin
            counter <= counter + 1; // Increment counter
            if (counter < CLK_HIGH_CYCLES) begin
                clk_div_int <= 1'b1; // Set intermediate clock signal high
            end else begin
                clk_div_int <= 1'b0; // Set intermediate clock signal low
            end
            if (counter == CLK_HIGH_CYCLES) begin
                clk_div_int_shifted <= ~clk_div_int; // Toggle phase-shifted intermediate clock signal
            end else begin
                clk_div_int_shifted <= clk_div_int; // Set phase-shifted intermediate clock signal
            end
        end
    end
end

always @(posedge clk) begin
    clk_div <= clk_div_int | clk_div_int_shifted; // Combine intermediate clock signals
end

endmodule