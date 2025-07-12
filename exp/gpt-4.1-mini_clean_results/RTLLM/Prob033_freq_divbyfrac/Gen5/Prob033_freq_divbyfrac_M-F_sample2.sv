module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // counts 0..6, total 7 cycles (for 3.5 division)

    reg [2:0] cnt;

    // Counter increments on posedge clk, resets to 0 on rst_n deassertion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clk_div_pos on posedge domain:
    // High for counts 0,1,2,3 (4 cycles)
    wire clk_div_pos = (cnt <= 3'd3);

    // Sample counter value at posedge clk for use at negedge clk
    reg [2:0] cnt_posedge_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_posedge_d <= 3'd0;
        else
            cnt_posedge_d <= cnt;
    end

    // Generate clk_div_neg on negedge clk domain:
    // High for counts 3,4,5,6 (4 cycles), low otherwise (3 cycles)
    reg clk_div_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else
            clk_div_neg <= (cnt_posedge_d >= 3'd3);
    end

    // Combine two phases to form fractional divided clock
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule