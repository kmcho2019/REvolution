module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // 3.5 division means output period = 7 input clk cycles (toggle every 3 or 4)
    // Counter counts 0..6 (7 states)
    reg [2:0] cnt;

    // Output clock registers toggled on posedge and negedge
    reg clk_div_rising;  // toggles on posedge clk at counts 3 and 6
    reg clk_div_falling; // toggles on negedge clk at counts 0 and 3

    // Combined output clock (double edge toggling)
    wire clk_div_comb;

    // Synchronous reset and counter increment at posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_div_rising <= 1'b0;
        end else begin
            // Increment count modulo 7
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div_rising at counts 3 and 6 (rising edge events)
            if ((cnt == 3'd3) || (cnt == 3'd6))
                clk_div_rising <= ~clk_div_rising;
        end
    end

    // Toggle clk_div_falling on negedge clk at counts 0 and 3 (falling edge events)
    // Because cnt changes at posedge clk, cnt is stable during negedge clk,
    // so we use cnt directly here for toggling.
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_falling <= 1'b1;
        end else begin
            if ((cnt == 3'd0) || (cnt == 3'd3))
                clk_div_falling <= ~clk_div_falling;
        end
    end

    // Combine rising and falling edge toggles using XOR to generate clk_div
    // XOR of two out-of-phase toggles creates a clock toggling on both edges,
    // effectively doubling toggling frequency to create the fractional output
    assign clk_div_comb = clk_div_rising ^ clk_div_falling;

    // Output
    assign clk_div = clk_div_comb;

endmodule