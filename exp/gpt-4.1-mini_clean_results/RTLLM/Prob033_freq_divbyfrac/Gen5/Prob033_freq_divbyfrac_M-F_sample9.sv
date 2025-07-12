module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam MAX_CNT = 3'd6; // counts 0..6 for 7 half cycles total (3.5 full cycles)

    // Counter increments on posedge clk, synchronous reset
    reg [2:0] cnt_pos;

    always @(posedge clk) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == MAX_CNT)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // clk_int_a toggles on posedge clk at cnt = 0 and 4
    reg clk_int_a;
    always @(posedge clk) begin
        if (!rst_n)
            clk_int_a <= 1'b0;
        else if (cnt_pos == 3'd0 || cnt_pos == 3'd4)
            clk_int_a <= ~clk_int_a;
    end

    // Sample counter at negedge clk for phase-shifted clock
    reg [2:0] cnt_neg;
    always @(negedge clk) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == MAX_CNT)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    // clk_int_b toggles on negedge clk at cnt = 2 and 6 (phase-shifted)
    reg clk_int_b;
    always @(negedge clk) begin
        if (!rst_n)
            clk_int_b <= 1'b0;
        else if (cnt_neg == 3'd2 || cnt_neg == 3'd6)
            clk_int_b <= ~clk_int_b;
    end

    // Final divided clock is logical OR of the two phase-shifted intermediate clocks
    assign clk_div = clk_int_a | clk_int_b;

endmodule