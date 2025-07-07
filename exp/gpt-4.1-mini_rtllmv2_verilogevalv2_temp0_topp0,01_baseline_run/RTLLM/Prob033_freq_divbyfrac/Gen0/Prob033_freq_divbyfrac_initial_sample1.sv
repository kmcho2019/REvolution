module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam integer MUL2_DIV_CLK = 7; // 2 * division factor (3.5 * 2 = 7)

    reg [2:0] cnt; // 3 bits to count 0..6
    reg clk_int_a; // intermediate clock A (aligned with clk posedge)
    reg clk_int_b; // intermediate clock B (aligned with clk negedge)

    // Counter increments on posedge clk, resets asynchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == MUL2_DIV_CLK - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clk_int_a on posedge clk
    // clk_int_a is high for 4 cycles, low for 3 cycles in each 7-cycle period
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_int_a <= 1'b0;
        else if (cnt < 4)
            clk_int_a <= 1'b1;
        else
            clk_int_a <= 1'b0;
    end

    // Generate clk_int_b on negedge clk
    // clk_int_b is high for 3 cycles, low for 4 cycles in each 7-cycle period
    // This creates the half-cycle phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_int_b <= 1'b0;
        else if (cnt < 3)
            clk_int_b <= 1'b1;
        else
            clk_int_b <= 1'b0;
    end

    // Final output clock is OR of the two intermediate clocks
    assign clk_div = clk_int_a | clk_int_b;

endmodule