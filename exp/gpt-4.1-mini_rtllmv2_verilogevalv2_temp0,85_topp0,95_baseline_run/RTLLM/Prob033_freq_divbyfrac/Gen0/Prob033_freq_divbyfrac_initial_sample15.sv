module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5
    localparam integer MUL2_DIV_CLK = 7; // 2 * 3.5

    reg [2:0] cnt_pos; // Counter for positive edge clock division
    reg [2:0] cnt_neg; // Counter for negative edge clock division

    reg clk_div_pos;
    reg clk_div_neg;

    // Counter increments on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == MUL2_DIV_CLK - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // Generate clk_div_pos: high for 4 cycles, low for 3 cycles
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos <= 1'b0;
        else if (cnt_pos < 4)
            clk_div_pos <= 1'b1;
        else
            clk_div_pos <= 1'b0;
    end

    // Counter increments on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == MUL2_DIV_CLK - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    // Generate clk_div_neg: high for 4 cycles, low for 3 cycles (phase shifted by half clock)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else if (cnt_neg < 4)
            clk_div_neg <= 1'b1;
        else
            clk_div_neg <= 1'b0;
    end

    // OR the two clocks to form the final fractional divided clock
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule