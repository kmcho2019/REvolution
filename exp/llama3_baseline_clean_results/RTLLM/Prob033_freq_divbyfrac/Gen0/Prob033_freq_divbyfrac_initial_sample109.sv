module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7;
parameter CLK_CYCLES_LONG = 4;
parameter CLK_CYCLES_SHORT = 3;

// Internal signals
reg [2:0] counter;
reg clk_div_int1;
reg clk_div_int2;
reg prev_clk;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and internal signals
        counter <= 0;
        clk_div_int1 <= 0;
        clk_div_int2 <= 0;
        prev_clk <= 0;
    end else begin
        // Increment the counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate the intermediate divided clock signals
        if (counter == CLK_CYCLES_LONG - 1) begin
            clk_div_int1 <= 1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int1 <= 0;
        end

        if (counter == CLK_CYCLES_SHORT - 1) begin
            clk_div_int2 <= 1;
        end else if (counter == CLK_CYCLES_LONG + CLK_CYCLES_SHORT - 1) begin
            clk_div_int2 <= 0;
        end

        // Generate the final fractional divided clock output
        if (prev_clk == 0 && clk == 1) begin
            // Rising edge, use clk_div_int1
            clk_div <= clk_div_int1;
        end else if (prev_clk == 1 && clk == 0) begin
            // Falling edge, use clk_div_int2
            clk_div <= clk_div_int2;
        end

        // Store the previous clock value
        prev_clk <= clk;
    end
end

endmodule