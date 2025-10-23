module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    localparam TOTAL_COUNT = 7;

    reg [2:0] count;          // Counter increments on posedge clk

    // Counter: counts 0 to 6 cyclically on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Registers for clk_pos and clk_neg
    reg clk_pos;
    reg clk_neg;

    // Generate clk_pos on posedge clk
    // clk_pos is high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else
            clk_pos <= (count <= 3'd3);
    end

    // Generate clk_neg on negedge clk
    // clk_neg is driven by count+1 modulo 7 to create half-cycle phase shift
    // clk_neg is high for 3 cycles (counts 3..5), low otherwise
    reg [2:0] count_next;
    always @(*) begin
        if (count == TOTAL_COUNT - 1)
            count_next = 3'd0;
        else
            count_next = count + 3'd1;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            // clk_neg high for counts 3,4,5; low otherwise
            clk_neg <= (count_next >= 3'd3 && count_next <= 3'd5);
    end

    // Output clock is OR of clk_pos and clk_neg
    assign clk_div = clk_pos | clk_neg;

endmodule