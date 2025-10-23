module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output reg  clk_div
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

    // Synchronous counter with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Generate clk_div1 and clk_div2 combinationally based on counter value
            // clk_div1 is high for counts [0, HALF_DIV -1]
            // clk_div2 is high for counts [HALF_DIV, NUM_DIV -1]
            // OR of clk_div1 and clk_div2 forms clk_div with the desired odd division
            // Since cnt is synchronous, clk_div changes on posedge clk synchronously
            if (cnt < HALF_DIV)
                clk_div <= 1'b1;  // clk_div1 high part
            else if (cnt >= HALF_DIV && cnt < NUM_DIV)
                clk_div <= 1'b1;  // clk_div2 high part
            else
                clk_div <= 1'b0;  // default low (should never reach here)
        end
    end

endmodule