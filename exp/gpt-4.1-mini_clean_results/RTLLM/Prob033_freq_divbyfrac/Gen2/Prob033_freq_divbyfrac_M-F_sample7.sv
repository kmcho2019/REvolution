module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for the fractional division: 3.5 = 7/2
    // Counter cycles from 0 to 6 (7 cycles total)
    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] count_pos;  // Counter updated on posedge clk
    reg [2:0] count_neg;  // Counter updated on negedge clk

    reg clk_int_a;  // Intermediate clock A, updated on posedge clk
    reg clk_int_b;  // Intermediate clock B, updated on negedge clk

    // Counter logic on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_pos <= 3'd0;
            clk_int_a <= 1'b0;
        end else begin
            // Increment counter modulo 7
            if (count_pos == MUL2_DIV_CLK - 1)
                count_pos <= 3'd0;
            else
                count_pos <= count_pos + 3'd1;

            // clk_int_a high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            // Generates the uneven pulse with longer high period on posedge clock domain
            if (count_pos < 4)
                clk_int_a <= 1'b1;
            else
                clk_int_a <= 1'b0;
        end
    end

    // Counter logic on negative edge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_neg <= 3'd0;
            clk_int_b <= 1'b0;
        end else begin
            // Increment counter modulo 7
            if (count_neg == MUL2_DIV_CLK - 1)
                count_neg <= 3'd0;
            else
                count_neg <= count_neg + 3'd1;

            // clk_int_b high for counts 0..2 (3 cycles), low for 3..6 (4 cycles)
            // Generates the uneven pulse with longer low period, phase shifted by half clock period
            if (count_neg < 3)
                clk_int_b <= 1'b1;
            else
                clk_int_b <= 1'b0;
        end
    end

    // Final fractional divided clock is OR of the two intermediate clocks
    assign clk_div = clk_int_a | clk_int_b;

endmodule