module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // NUM_DIV must be odd. Synthesis tools may ignore this comment, 
    // so ensure parameter is odd during instantiation.
    // For example: 3,5,7,...

    // Calculate toggle points for posedge and negedge counters
    // For odd NUM_DIV:
    // Toggle clk_div1 on posedge when cnt1 == (NUM_DIV-1)/2
    // Toggle clk_div2 on negedge when cnt2 == (NUM_DIV/2)
    localparam POS_TOGGLE_CNT = (NUM_DIV - 1) >> 1; // (NUM_DIV-1)/2
    localparam NEG_TOGGLE_CNT = NUM_DIV >> 1;       // NUM_DIV/2

    // Width for counters
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Positive edge counter and clk_div1 toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            if (cnt1 == POS_TOGGLE_CNT)
                clk_div1 <= ~clk_div1;
        end
    end

    // Negative edge counter and clk_div2 toggle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            if (cnt2 == NEG_TOGGLE_CNT)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule