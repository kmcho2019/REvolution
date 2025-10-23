module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam DIV_COUNT = 7; // 3.5 x division means cycle length 7
    localparam HALF_HIGH_COUNT = 4; // high for 4 cycles
    localparam HALF_LOW_COUNT  = 3; // low for 3 cycles

    // Counter on posedge clk - counts 0 to 6
    reg [2:0] pos_counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pos_counter <= 3'd0;
        else if (pos_counter == DIV_COUNT - 1)
            pos_counter <= 3'd0;
        else
            pos_counter <= pos_counter + 3'd1;
    end

    // clk_pos output: high when pos_counter < 4, else low
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else
            clk_pos <= (pos_counter < HALF_HIGH_COUNT);
    end

    // Counter on negedge clk - counts 0 to 6
    reg [2:0] neg_counter;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg_counter <= 3'd0;
        else if (neg_counter == DIV_COUNT - 1)
            neg_counter <= 3'd0;
        else
            neg_counter <= neg_counter + 3'd1;
    end

    // clk_neg output: high when neg_counter < 4, else low
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= (neg_counter < HALF_HIGH_COUNT);
    end

    // OR both phase-shifted clocks to get final fractional clock output
    assign clk_div = clk_pos | clk_neg;

endmodule