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

    // Width for counters
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for positive and negative edges
    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;

    // Toggles for clk_div1 and clk_div2
    reg clk_div1;
    reg clk_div2;

    // Half point for toggling (integer division)
    localparam integer HALF_DIV = NUM_DIV / 2;

    // Positive edge clock domain: cnt1 and clk_div1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;  // Toggle at terminal count on positive edge
            end else if (cnt1 == HALF_DIV) begin
                cnt1 <= cnt1 + 1;
                clk_div1 <= ~clk_div1;  // Toggle at half count on positive edge
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Negative edge clock domain: cnt2 and clk_div2
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;  // Toggle at terminal count on negative edge
            end else if (cnt2 == HALF_DIV) begin
                cnt2 <= cnt2 + 1;
                clk_div2 <= ~clk_div2;  // Toggle at half count on negative edge
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    // Output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule