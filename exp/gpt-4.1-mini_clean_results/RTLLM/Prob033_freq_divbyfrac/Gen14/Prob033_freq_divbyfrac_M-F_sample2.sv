module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_NUM = 7; // 7 input clocks per output clock period (3.5 division)

    // Counter counts 0..6
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_NUM - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_pos toggles on posedge clk at cnt=0 and cnt=4
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0; // start low so output initially low
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles on negedge clk when cnt == 3 or cnt == 6
    // Using combinational toggle request directly from current cnt
    reg clk_neg;
    wire toggle_neg = (cnt == 3'd3) || (cnt == 3'd6);

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b1; // start complementary to clk_pos for proper duty cycle
        else if (toggle_neg)
            clk_neg <= ~clk_neg;
    end

    // Output is OR of both clocks producing the fractional divided clock with half-clock phase shift
    assign clk_div = clk_pos | clk_neg;

endmodule