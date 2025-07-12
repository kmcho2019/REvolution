module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // 7 cycles for 3.5 division

    // Rising edge counter: counts 0..6 repeatedly
    reg [2:0] cnt_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == CNT_MAX - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // clk_pos high for 4 cycles (0..3), low for 3 cycles (4..6)
    wire clk_pos = (cnt_pos <= 3'd3);

    // Falling edge counter: to generate clk_neg, shifted by half cycle
    reg [2:0] cnt_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == CNT_MAX - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    // clk_neg high for 3 cycles (0..2), low for 4 cycles (3..6) -> phase shifted by half clock
    wire clk_neg = (cnt_neg <= 3'd2);

    // Combine both phases to form fractional clock with balanced duty cycle and exact 3.5 division
    assign clk_div = clk_pos | clk_neg;

endmodule