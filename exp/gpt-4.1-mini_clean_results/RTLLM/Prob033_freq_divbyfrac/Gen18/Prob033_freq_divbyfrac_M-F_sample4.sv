module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division 3.5 = 7/2
    localparam integer DIV_RATIO = 7;

    // Counter for counting 0 to 6
    reg [2:0] cnt;

    // Intermediate clocks
    reg clk_div_even;
    reg clk_div_odd;

    // Counter and clk_div_even generation on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt         <= 3'd0;
            clk_div_even <= 1'b0;
        end else begin
            // Increment counter modulo DIV_RATIO
            if (cnt == DIV_RATIO - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div_even at counts 3 and 6 to create high=4 cycles, low=3 cycles pattern
            if ((cnt == 3) || (cnt == 6))
                clk_div_even <= ~clk_div_even;
        end
    end

    // Generate clk_div_odd by sampling clk_div_even on negative edge of clk (half cycle delay)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_odd <= 1'b0;
        end else begin
            clk_div_odd <= clk_div_even;
        end
    end

    // Final fractional divided clock output by OR-ing two intermediate clocks
    assign clk_div = clk_div_even | clk_div_odd;

endmodule