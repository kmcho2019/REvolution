module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd, >=3
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output wire clk_div
);

    // Compile-time checks
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
        if (NUM_DIV < 3) begin
            $error("NUM_DIV parameter must be >= 3.");
        end
    end

    localparam MID_POINT = (NUM_DIV - 1) >> 1; // (NUM_DIV-1)/2
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1 = 0;
    reg [CNT_WIDTH-1:0] cnt2 = 0;
    reg clk_div1 = 0;
    reg clk_div2 = 0;

    // Counter and clk_div1 update on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;  // toggle at end of count
            end else begin
                cnt1 <= cnt1 + 1;
                // Toggle clk_div1 at midpoint count
                if (cnt1 == MID_POINT)
                    clk_div1 <= ~clk_div1;
            end
        end
    end

    // Counter and clk_div2 update on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;  // toggle at end of count
            end else begin
                cnt2 <= cnt2 + 1;
                // Toggle clk_div2 at midpoint count
                if (cnt2 == MID_POINT)
                    clk_div2 <= ~clk_div2;
            end
        end
    end

    // Final divided clock output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule