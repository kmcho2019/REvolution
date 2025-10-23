module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Synthesis-time check for odd NUM_DIV (non-synthesizable but common practice)
    generate
        if (NUM_DIV % 2 == 0) begin
            initial begin
                $error("NUM_DIV parameter must be an odd number.");
            end
        end
    endgenerate

    localparam MID_VAL = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge
    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    // Toggle pulse signals (combinational)
    wire toggle_pos_edge = (cnt_pos == MID_VAL);
    wire toggle_neg_edge = (cnt_neg == MID_VAL);

    // Divided clocks toggled on pulses
    reg clk_div1; // toggled on posedge clk
    reg clk_div2; // toggled on negedge clk

    // Positive edge counter and toggle pulse handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos  <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1) begin
                cnt_pos <= 0;
            end else begin
                cnt_pos <= cnt_pos + 1;
            end

            if (toggle_pos_edge) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge counter and toggle pulse handling
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg  <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1) begin
                cnt_neg <= 0;
            end else begin
                cnt_neg <= cnt_neg + 1;
            end

            if (toggle_neg_edge) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Final output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule