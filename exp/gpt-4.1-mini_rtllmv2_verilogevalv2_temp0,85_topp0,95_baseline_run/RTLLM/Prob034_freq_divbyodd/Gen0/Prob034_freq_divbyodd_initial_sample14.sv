module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check that NUM_DIV is odd and >= 3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
            $finish;
        end
    end

    localparam HALF_DIV = NUM_DIV >> 1; // integer division by 2

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 toggled on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            // Toggle clk_div1 at half count
            if (cnt1 == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter and clk_div2 toggled on falling edge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            // Toggle clk_div2 at half count
            if (cnt2 == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule