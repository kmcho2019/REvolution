module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter modulo 7 (for 3.5 division = 7/2)
    reg [2:0] cnt;

    // Intermediate clocks
    reg clk_div1; // toggled on posedge clk at uneven intervals (4 and 3 cycles)
    reg clk_div2; // toggled on negedge clk at uneven intervals (phase shifted clk_div1)

    // Count on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_div1 <= 1'b0;
        end else begin
            // Increment modulo 7 counter
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div1 at count values:
            // After 4 counts and after 3 counts alternately to generate uneven cycle length
            // Let's toggle when cnt == 3 or cnt == 6
            // Pattern: toggle at cnt == 3 and cnt == 6 on posedge
            if ((cnt == 3'd3) || (cnt == 3'd6))
                clk_div1 <= ~clk_div1;
        end
    end

    // Toggle clk_div2 at negedge clk at the opposite counts to achieve 0.5 clock phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            // cnt updates only on posedge clk, so to check cnt synchronized with negedge clk,
            // use the current cnt value from posedge domain.
            // Toggle clk_div2 at cnt == 0 or cnt == 4 on negedge clk.
            if ((cnt == 3'd0) || (cnt == 3'd4))
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of two phase-shifted intermediate clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule