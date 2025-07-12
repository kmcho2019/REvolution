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

    localparam integer HALF_DIV = NUM_DIV / 2;

    // Width for counters (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;
    reg clk_div1, clk_div2;

    // Single synchronous counter, increment every posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 1'b0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end

            // clk_div1 goes high at cnt == 0, low at cnt == HALF_DIV
            if (cnt == 0) begin
                clk_div1 <= 1'b1;
            end else if (cnt == HALF_DIV) begin
                clk_div1 <= 1'b0;
            end

            // clk_div2 goes high at cnt == HALF_DIV + 1 modulo NUM_DIV, low at cnt == (HALF_DIV + HALF_DIV +1) modulo NUM_DIV
            // To approximate toggling at negative edge, offset clk_div2 by HALF_DIV+1 counts
            // Compute these points with modulo arithmetic
            else if (cnt == ((HALF_DIV + 1) % NUM_DIV)) begin
                clk_div2 <= 1'b1;
            end else if (cnt == ((HALF_DIV + HALF_DIV + 1) % NUM_DIV)) begin
                clk_div2 <= 1'b0;
            end
            // Otherwise, clk_div1 and clk_div2 retain previous states
        end
    end

    // Final output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule