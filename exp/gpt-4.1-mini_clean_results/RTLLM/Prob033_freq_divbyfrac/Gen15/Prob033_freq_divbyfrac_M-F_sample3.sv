module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7;         // Divide by 7 cycles total = 3.5 division
    localparam POS_HIGH_CYCLES = 4;   // clk_pos high for 4 cycles (0..3)
    localparam NEG_HIGH_CYCLES = 3;   // clk_neg high for 3 cycles (0..2)

    // Posedge clock domain counter: counts 0 to 6
    reg [2:0] pos_count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pos_count <= 3'd0;
        else if (pos_count == DIV_COUNT - 1)
            pos_count <= 3'd0;
        else
            pos_count <= pos_count + 3'd1;
    end

    // clk_pos high for counts 0..3, low for 4..6
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else
            clk_pos <= (pos_count < POS_HIGH_CYCLES);
    end

    // Negedge clock domain counter: counts 0 to 6, phase shifted by half clk period
    reg [2:0] neg_count;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg_count <= 3'd0;
        else if (neg_count == DIV_COUNT - 1)
            neg_count <= 3'd0;
        else
            neg_count <= neg_count + 3'd1;
    end

    // clk_neg high for counts 0..2 (3 cycles), low for 3..6 (4 cycles)
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= (neg_count < NEG_HIGH_CYCLES);
    end

    // Final fractional clock: OR of posedge and negedge clocks
    assign clk_div = clk_pos | clk_neg;

endmodule