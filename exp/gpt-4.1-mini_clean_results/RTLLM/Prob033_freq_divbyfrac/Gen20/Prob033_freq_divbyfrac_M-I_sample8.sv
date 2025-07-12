module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Positive edge counter: counts 0..3 (4 cycles)
    reg [1:0] cnt_pos;
    wire      pulse_pos;

    always @(posedge clk) begin
        if (!rst_n)
            cnt_pos <= 2'd0;
        else if (cnt_pos == 2'd3)
            cnt_pos <= 2'd0;
        else
            cnt_pos <= cnt_pos + 2'd1;
    end

    assign pulse_pos = (cnt_pos == 2'd3);

    // Negative edge counter: counts 0..2 (3 cycles)
    reg [1:0] cnt_neg;
    wire      pulse_neg;

    always @(negedge clk) begin
        if (!rst_n)
            cnt_neg <= 2'd0;
        else if (cnt_neg == 2'd2)
            cnt_neg <= 2'd0;
        else
            cnt_neg <= cnt_neg + 2'd1;
    end

    assign pulse_neg = (cnt_neg == 2'd2);

    // Intermediate clock toggled on rollover pulses
    reg clk_div_pos_int;
    reg clk_div_neg_int;

    // Toggle intermediate clock on posedge clock rollover pulse
    always @(posedge clk) begin
        if (!rst_n)
            clk_div_pos_int <= 1'b0;
        else if (pulse_pos)
            clk_div_pos_int <= ~clk_div_pos_int;
    end

    // Toggle intermediate clock on negedge clock rollover pulse
    always @(negedge clk) begin
        if (!rst_n)
            clk_div_neg_int <= 1'b0;
        else if (pulse_neg)
            clk_div_neg_int <= ~clk_div_neg_int;
    end

    // OR of two intermediate clocks yields final fractional clock output
    assign clk_div = clk_div_pos_int | clk_div_neg_int;

endmodule