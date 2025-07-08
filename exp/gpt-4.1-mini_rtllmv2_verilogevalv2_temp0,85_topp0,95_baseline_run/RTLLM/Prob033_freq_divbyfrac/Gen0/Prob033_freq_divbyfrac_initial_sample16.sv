module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam integer MUL2_DIV_CLK = 7; // 2 * division factor (3.5 * 2 = 7)
    localparam integer HALF_DIV    = MUL2_DIV_CLK / 2; // 3 (floor of 7/2)
    localparam integer FULL_DIV    = MUL2_DIV_CLK;     // 7

    // Counter running on posedge clk
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 0;
        else if (cnt == (MUL2_DIV_CLK - 1))
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    // Intermediate clk signal generated on posedge clk
    // High for 4 cycles, low for 3 cycles => uneven cycles for 3.5 division
    // Let's define high interval from cnt=0 to cnt=3 (4 cycles high)
    reg clk_div_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos <= 1'b0;
        else if (cnt < 4)  // counts 0,1,2,3: high
            clk_div_pos <= 1'b1;
        else
            clk_div_pos <= 1'b0;
    end

    // Counter running on negedge clk for phase shifted clock
    reg [2:0] cnt_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 0;
        else if (cnt_neg == (MUL2_DIV_CLK - 1))
            cnt_neg <= 0;
        else
            cnt_neg <= cnt_neg + 1;
    end

    // Intermediate clk signal generated on negedge clk (phase shifted by half clk period)
    reg clk_div_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else if (cnt_neg < 4)
            clk_div_neg <= 1'b1;
        else
            clk_div_neg <= 1'b0;
    end

    // Final divided clock by OR'ing both intermediate clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule