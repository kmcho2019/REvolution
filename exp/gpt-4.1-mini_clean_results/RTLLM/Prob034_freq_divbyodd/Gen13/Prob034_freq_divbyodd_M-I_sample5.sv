module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd and >=3
)(
    input  wire clk,
    input  wire rst_n,   // Active low synchronous reset
    output wire clk_div
);

    // Compile-time checks
    initial begin
        if (NUM_DIV < 3) begin
            $error("NUM_DIV parameter must be >= 3.");
        end
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be odd.");
        end
    end

    localparam HALF_DIV = (NUM_DIV >> 1);
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;

    reg clk_div1;
    reg clk_div2;

    // Counter and toggle clk_div1 on rising edge of clk
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            // Toggle clk_div1 at counts HALF_DIV-1 and NUM_DIV-1
            if ((cnt1 == HALF_DIV - 1) || (cnt1 == NUM_DIV - 1))
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter and toggle clk_div2 on falling edge of clk
    always @(negedge clk) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            // Toggle clk_div2 at counts HALF_DIV-1 and NUM_DIV-1
            if ((cnt2 == HALF_DIV - 1) || (cnt2 == NUM_DIV - 1))
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule