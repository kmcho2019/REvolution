module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for the fractional division: 3.5 = 7/2
    // Counter cycles from 0 to 6 (7 counts total)
    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] count_pos;       // Counter updated on posedge clk
    reg [2:0] count_neg_reg;   // Counter sampled on negedge clk domain (phase shifted)

    // Synchronous counter on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_pos <= 3'd0;
        end else begin
            if (count_pos == MUL2_DIV_CLK - 1)
                count_pos <= 3'd0;
            else
                count_pos <= count_pos + 3'd1;
        end
    end

    // Register the counter value on negedge clk to create phase-shifted count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_neg_reg <= 3'd0;
        end else begin
            count_neg_reg <= count_pos;
        end
    end

    // Generate intermediate clock A combinationally from posedge counter
    // High for counts 0..3 (4 cycles), low otherwise
    wire clk_int_a = (count_pos < 4);

    // Generate intermediate clock B combinationally from phase shifted count (sampled on negedge)
    // High for counts 0..2 (3 cycles), low otherwise
    wire clk_int_b = (count_neg_reg < 3);

    // Final fractional divided clock is OR of intermediate clocks
    assign clk_div = clk_int_a | clk_int_b;

endmodule