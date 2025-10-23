module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7;
parameter DIV_CLK_CYCLES_1 = 4;
parameter DIV_CLK_CYCLES_2 = 3;

reg [2:0] counter; // Counter for 7 clock cycles
reg clk_int1, clk_int2; // Intermediate clock signals
reg clk_int1_delayed, clk_int2_advanced; // Phase-shifted clock signals
reg prev_clk; // Previous clock value for edge detection

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        clk_int1 <= 0;
        clk_int2 <= 0;
        clk_int1_delayed <= 0;
        clk_int2_advanced <= 0;
        prev_clk <= 0;
        clk_div <= 0;
    end else begin
        // Update previous clock value
        prev_clk <= clk;

        // Update counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate clock signals
        if (counter == DIV_CLK_CYCLES_1 - 1) begin
            clk_int1 <= 1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 0;
        end

        if (counter == DIV_CLK_CYCLES_2 - 1) begin
            clk_int2 <= 1;
        end else if (counter == DIV_CLK_CYCLES_1 + DIV_CLK_CYCLES_2 - 1) begin
            clk_int2 <= 0;
        end

        // Phase-shift intermediate clock signals
        if (prev_clk == 0 && clk == 1) begin // Rising edge
            clk_int1_delayed <= clk_int1;
            clk_int2_advanced <= clk_int2;
        end else if (prev_clk == 1 && clk == 0) begin // Falling edge
            clk_int1_delayed <= 0;
            clk_int2_advanced <= 0;
        end

        // Generate final fractional divided clock output
        clk_div <= clk_int1_delayed | clk_int2_advanced;
    end
end

endmodule