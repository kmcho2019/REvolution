module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Counter: increments modulo NUM_DIV on posedge clk with async reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 0;
        else if (cnt == NUM_DIV - 1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    // Generate clk_div1: high when cnt in [0, HALF_DIV-1], low otherwise
    wire clk_div1 = (cnt < HALF_DIV);

    // Generate clk_div2: phase shifted clk_div1 by HALF_DIV counts, with wraparound
    // Calculate (cnt + HALF_DIV) mod NUM_DIV and check if less than HALF_DIV
    wire [$clog2(NUM_DIV):0] cnt_shifted = cnt + HALF_DIV;
    wire clk_div2 = ((cnt_shifted >= NUM_DIV) ? (cnt_shifted - NUM_DIV) : cnt_shifted) < HALF_DIV;

    // Final output: OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule