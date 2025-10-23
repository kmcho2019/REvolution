module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] cnt;

    // Counter counts from 0 to 6 repeatedly on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == 3'd6)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clock enables for posedge and negedge flip-flops
    // ce_pos active when cnt in [0..3] (4 cycles)
    wire ce_pos = (cnt <= 3'd3);
    // ce_neg active when cnt in [4..6] (3 cycles)
    wire ce_neg = (cnt >= 3'd4);

    reg clk_intA; // toggles on posedge clk when ce_pos asserted
    reg clk_intB; // toggles on negedge clk when ce_neg asserted

    // Toggle clk_intA on posedge clk when ce_pos is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA <= 1'b0;
        else if (ce_pos)
            clk_intA <= ~clk_intA;
        else
            clk_intA <= clk_intA; // hold state when ce_pos is low
    end

    // Toggle clk_intB on negedge clk when ce_neg is high
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB <= 1'b0;
        else if (ce_neg)
            clk_intB <= ~clk_intB;
        else
            clk_intB <= clk_intB; // hold state when ce_neg is low
    end

    // Output clock is OR of two half-cycle shifted internal clocks
    assign clk_div = clk_intA | clk_intB;

endmodule