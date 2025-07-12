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

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counters (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;

    reg clk_div1;
    reg clk_div2;

    // Positive edge counter and clk_div1 generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            // Set clk_div1 high at cnt1 == 0
            if (cnt1 == 0) begin
                clk_div1 <= 1'b1;
            // Clear clk_div1 at cnt1 == HALF_DIV
            end else if (cnt1 == HALF_DIV) begin
                clk_div1 <= 1'b0;
            end
            // Otherwise maintain current clk_div1
        end
    end

    // Negative edge counter and clk_div2 generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            // Set clk_div2 high at cnt2 == 0
            if (cnt2 == 0) begin
                clk_div2 <= 1'b1;
            // Clear clk_div2 at cnt2 == HALF_DIV
            end else if (cnt2 == HALF_DIV) begin
                clk_div2 <= 1'b0;
            end
            // Otherwise maintain current clk_div2
        end
    end

    // Final output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule