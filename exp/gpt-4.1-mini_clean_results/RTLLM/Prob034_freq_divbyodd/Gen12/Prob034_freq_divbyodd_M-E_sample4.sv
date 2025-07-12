module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) / 2; // Midpoint toggle count for odd divisor
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge
    reg [CNT_WIDTH-1:0] cnt1; // posedge clk counter
    reg [CNT_WIDTH-1:0] cnt2; // negedge clk counter

    // Clock divide outputs toggled at half count
    reg clk_div1;
    reg clk_div2;

    // Counter and toggle logic on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            // Toggle clk_div1 when cnt1 reaches HALF_COUNT
            if (cnt1 == HALF_COUNT)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter and toggle logic on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            // Toggle clk_div2 when cnt2 reaches HALF_COUNT
            if (cnt2 == HALF_COUNT)
                clk_div2 <= ~clk_div2;
        end
    end

    // Final divided clock is OR of both toggles to combine edges
    assign clk_div = clk_div1 | clk_div2;

endmodule