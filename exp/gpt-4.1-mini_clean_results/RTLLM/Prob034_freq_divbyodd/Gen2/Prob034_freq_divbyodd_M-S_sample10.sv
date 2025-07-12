module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check that NUM_DIV is odd at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd, but is %0d", NUM_DIV);
        end
    end

    localparam HALF_DIV = (NUM_DIV - 1) / 2;

    reg [$clog2(NUM_DIV)-1:0] cnt1;      // Counter for posedge
    reg [$clog2(NUM_DIV)-1:0] cnt2;      // Counter for negedge
    reg clk_div1, clk_div2;

    // Count and toggle on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            if (cnt1 == HALF_DIV)
                clk_div1 <= ~clk_div1;
            else if (cnt1 == NUM_DIV - 1)
                clk_div1 <= ~clk_div1;
        end
    end

    // Count and toggle on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            if (cnt2 == HALF_DIV)
                clk_div2 <= ~clk_div2;
            else if (cnt2 == NUM_DIV - 1)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combine the two divided clocks to generate final output
    assign clk_div = clk_div1 | clk_div2;

endmodule