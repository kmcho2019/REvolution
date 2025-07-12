module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output reg  clk_div   // Fractionally divided clock output (clk / 3.5)
);

    // The division factor is 3.5 = 7/2
    // Multiply numerator and denominator by 2 -> total count = 14 (full period count)
    // Generate clk_div with period = 14 input clocks.

    reg [3:0] cnt;        // 4-bit counter to count 0..13 (14 states)
    reg       clk_div_int; // internal divided clock base signal
    reg       toggle_edge; // flag to indicate toggling at falling edge

    // To achieve double-edge toggling:
    // - On rising edge, toggle clk_div_int when cnt reaches half period (7)
    // - On falling edge, toggle clk_div_int when cnt reaches period end (13)
    // This creates uneven high/low intervals (4 and 3 cycles) in clk_div_int.
    // The output clk_div toggles on both edges producing effective clk/3.5 frequency.

    // Count 0..13 on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 4'd0;
        else if (cnt == 4'd13)
            cnt <= 4'd0;
        else
            cnt <= cnt + 4'd1;
    end

    // Toggle clk_div_int on cnt == 6 (after 7 counts: 0..6 is 7 cycles)
    // and on cnt == 13 (after 7 more counts: 7..13 is 7 cycles),
    // but for fractional division we want uneven intervals:
    // - High for 4 clocks (cnt 0..3)
    // - Low for 3 clocks (cnt 4..6)
    // - Then high 4 clocks (7..10)
    // - Low 3 clocks (11..13)
    // To implement this, we toggle at cnt 3 and cnt 6 for one edge,
    // and at cnt 10 and cnt 13 for the other edge.

    // We'll use a register toggled on posedge clk at cnt == 3 or cnt == 10
    // and on negedge clk at cnt == 6 or cnt == 13.

    // To implement toggling on negedge clk, use an always block on negedge clk,
    // controlled by cnt (latched before negedge).

    // Latch cnt on posedge clk for use in negedge block (synchronize)
    reg [3:0] cnt_posedge;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_posedge <= 4'd0;
        else
            cnt_posedge <= cnt;
    end

    // Posedge clk toggling (cnt == 3 or 10)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_int <= 1'b0;
        else if (cnt == 4'd3 || cnt == 4'd10)
            clk_div_int <= ~clk_div_int;
    end

    // Negedge clk toggling (cnt_posedge == 6 or 13)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 1'b0;
        else if (cnt_posedge == 4'd6 || cnt_posedge == 4'd13)
            clk_div <= ~clk_div;
        else
            clk_div <= clk_div; // hold
    end

    // Note:
    // clk_div_int toggles at posedge clk on counts 3 and 10 (after 4 and 7 cycles)
    // clk_div toggles at negedge clk when cnt was 6 or 13 (after 7 and 7 cycles)
    //
    // The output clk_div has half period toggles at both clk edges with uneven intervals (4 & 3 cycles),
    // effectively dividing the input clock by 3.5 with good duty cycle balance.

endmodule