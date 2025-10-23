module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // 7 counts (0..6) for divide by 3.5

    reg [2:0] cnt_posedge;
    reg [2:0] cnt_negedge;

    // Counter increments on posedge clk, resets on rst_n deassertion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_posedge <= 3'd0;
        else if (cnt_posedge == CNT_MAX - 1)
            cnt_posedge <= 3'd0;
        else
            cnt_posedge <= cnt_posedge + 3'd1;
    end

    // Sample the posedge counter at negedge clk to get phase-shifted count
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_negedge <= 3'd0;
        else
            cnt_negedge <= cnt_posedge;
    end

    // clk_div_pos is high for counts 0..3 (4 cycles)
    wire clk_div_pos = (cnt_posedge <= 3'd3);

    // clk_div_neg is high for counts 4..6 (3 cycles)
    wire clk_div_neg = (cnt_negedge >= 3'd4);

    // OR both phases to generate fractional divided clock
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule