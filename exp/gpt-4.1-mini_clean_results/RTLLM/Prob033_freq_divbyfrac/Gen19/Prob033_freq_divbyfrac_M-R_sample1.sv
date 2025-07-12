module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Positive edge counter: counts 0..3 (4 cycles)
    reg [1:0] cnt_pos;
    wire      pulse_pos;  // pulse generated when cnt_pos rolls over

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 2'd0;
        end else begin
            if (cnt_pos == 2'd3)
                cnt_pos <= 2'd0;
            else
                cnt_pos <= cnt_pos + 2'd1;
        end
    end

    assign pulse_pos = (cnt_pos == 2'd3); // pulse on rollover at posedge

    // Negative edge counter: counts 0..2 (3 cycles)
    reg [1:0] cnt_neg;
    wire      pulse_neg;  // pulse generated when cnt_neg rolls over

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 2'd0;
        end else begin
            if (cnt_neg == 2'd2)
                cnt_neg <= 2'd0;
            else
                cnt_neg <= cnt_neg + 2'd1;
        end
    end

    assign pulse_neg = (cnt_neg == 2'd2); // pulse on rollover at negedge

    // Intermediate clocks toggled on pulse edges
    reg clk_div_pos_int;
    reg clk_div_neg_int;

    // Toggle clk_div_pos_int at posedge pulse
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos_int <= 1'b0;
        else if (pulse_pos)
            clk_div_pos_int <= ~clk_div_pos_int;
    end

    // Toggle clk_div_neg_int at negedge pulse (clk negedge)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg_int <= 1'b0;
        else if (pulse_neg)
            clk_div_neg_int <= ~clk_div_neg_int;
    end

    // Final output clock is the OR of the two intermediate clocks
    assign clk_div = clk_div_pos_int | clk_div_neg_int;

endmodule