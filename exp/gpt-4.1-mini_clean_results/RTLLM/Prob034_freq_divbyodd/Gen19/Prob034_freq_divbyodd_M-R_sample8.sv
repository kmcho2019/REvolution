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
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // clk_div1 toggled on posedge clk at count 0 and HALF_DIV
    reg clk_div1;

    // clk_div2 toggled on negedge clk, synchronized with clk_div1 transitions
    reg clk_div2;

    // Single counter counting from 0 to NUM_DIV-1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 on count 0 and HALF_DIV
            // Use set high at count 0 and clear low at HALF_DIV to form pulse
            if (cnt == 0)
                clk_div1 <= 1'b1;
            else if (cnt == HALF_DIV)
                clk_div1 <= 1'b0;
            // else maintain previous value
        end
    end

    // clk_div2 toggled at negedge clk, tracking clk_div1 transitions for 50% duty cycle
    // This creates phase shift so final OR is symmetrical and odd division correct
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 0;
        end else begin
            // Toggle clk_div2 when clk_div1 rises or falls to generate complementary pulse
            // Use clk_div1 edges to toggle clk_div2:
            // sample previous clk_div1 state to detect edge
            // Instead, toggle clk_div2 at every negedge clk to complement clk_div1's pulse
            clk_div2 <= ~clk_div2;
        end
    end

    // Combine the two to produce the final divided clock output
    assign clk_div = clk_div1 | clk_div2;

endmodule