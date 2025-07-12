module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7;

    // Single counter running on posedge clk
    reg [2:0] count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos is high for 4 counts (0..3), low otherwise
    wire clk_pos = (count < 4);

    // clk_neg is clk_pos delayed by half clock period (sampled on negedge clk)
    reg clk_pos_dly;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos_dly <= 1'b0;
        else
            clk_pos_dly <= clk_pos;
    end

    wire clk_neg = clk_pos_dly;

    // OR clk_pos and clk_neg to form final clock with fractional division and 50% duty cycle
    assign clk_div = clk_pos | clk_neg;

endmodule