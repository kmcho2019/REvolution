module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low synchronous reset
    output wire clk_div
);

    // Check NUM_DIV is odd at elaboration time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be odd");
        end
    end

    localparam HALF_DIV = NUM_DIV / 2;

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters on posedge and negedge clk
    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    // Divided clocks on posedge and negedge
    reg clk_div1;
    reg clk_div2;

    // Positive edge counter and clk_div1 toggle logic
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1'b1;

            if (cnt_pos == 0)
                clk_div1 <= 1'b1;
            else if (cnt_pos == HALF_DIV)
                clk_div1 <= 1'b0;
        end
    end

    // Negative edge counter and clk_div2 toggle logic
    always @(negedge clk) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1'b1;

            if (cnt_neg == 0)
                clk_div2 <= 1'b1;
            else if (cnt_neg == HALF_DIV)
                clk_div2 <= 1'b0;
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule