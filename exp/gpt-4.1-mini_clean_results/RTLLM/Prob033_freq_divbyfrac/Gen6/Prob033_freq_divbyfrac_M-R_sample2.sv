module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam TOTAL_COUNT = 7;

    // Counter counts from 0 to 6 on rising edge of clk
    reg [2:0] count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_A high for counts 0..3 (4 counts)
    wire clk_A = (count < 4);

    // Calculate shifted count: (count + 3) mod 7
    wire [3:0] shifted_count = count + 3; // 3-bit + 3-bit addition max 6+3=9 fits in 4 bits
    wire [2:0] shifted_mod = (shifted_count >= TOTAL_COUNT) ? (shifted_count - TOTAL_COUNT) : shifted_count;

    // clk_B high for shifted counts 0..2 (3 counts)
    wire clk_B = (shifted_mod < 3);

    // Output clock is OR of clk_A and clk_B
    assign clk_div = clk_A | clk_B;

endmodule