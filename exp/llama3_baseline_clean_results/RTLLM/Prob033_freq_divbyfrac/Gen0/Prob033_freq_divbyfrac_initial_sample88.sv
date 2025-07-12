module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Define parameters
parameter MUL2_DIV_CLK = 7; // Total clock cycles for the counter

// Internal signals
reg [2:0] counter; // 3-bit counter
reg clk_div_int1; // Intermediate divided clock signal 1 (4 source clock cycles)
reg clk_div_int2; // Intermediate divided clock signal 2 (3 source clock cycles)
reg clk_div_int1_ph; // Phase-shifted version of clk_div_int1 (delayed by half a clock period)
reg clk_div_int2_ph; // Phase-shifted version of clk_div_int2 (advanced by half a clock period)

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div_int1 <= 0;
        clk_div_int2 <= 0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate uneven clock periods
        if (counter < 4) begin
            clk_div_int1 <= 1;
        end else begin
            clk_div_int1 <= 0;
        end

        if ((counter >= 4 && counter < 7) || (counter == 0 && !clk_div_int2)) begin
            clk_div_int2 <= 1;
        end else begin
            clk_div_int2 <= 0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk) begin
    // Delay clk_div_int1 by half a clock period
    clk_div_int1_ph <= clk_div_int1;

    // Advance clk_div_int2 by half a clock period (use previous value of clk_div_int2)
    clk_div_int2_ph <= clk_div_int2;
end

// Final divided clock output
always @(posedge clk) begin
    // Logically OR the two intermediate clocks
    clk_div <= clk_div_int1_ph | clk_div_int2_ph;
end

endmodule