module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF_COUNT = NUM_DIV >> 1;

    // Width of counters sufficient to hold NUM_DIV-1
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;    // Counter for positive edge
    reg [CNT_WIDTH-1:0] cnt2;    // Counter for negative edge

    reg clk_div1, clk_div2;      // Clock divider signals toggled on posedge and negedge

    // Positive edge counter and clk_div1 toggle logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            if (cnt1 == HALF_COUNT)
                clk_div1 <= ~clk_div1;
        end
    end

    // Negative edge counter and clk_div2 toggle logic
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            if (cnt2 == HALF_COUNT)
                clk_div2 <= ~clk_div2;
        end
    end

    // Final divided clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule