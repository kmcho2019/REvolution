module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5 (3.5 * 2 = 7)
    localparam integer MUL2_DIV_CLK = 7;  // Double count of division
    localparam integer HIGH_COUNT   = 4;  // High period in input clk cycles
    localparam integer LOW_COUNT    = 3;  // Low period in input clk cycles

    reg [2:0] cnt;       // 3-bit counter (0 to 6)
    reg       div_clk_a; // Divided clock phase A (updated on posedge clk)
    reg       div_clk_b; // Divided clock phase B (phase shifted, updated on negedge clk)

    // Counter and div_clk_a generation on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 3'd0;
            div_clk_a <= 1'b0;
        end else begin
            // Increment counter and wrap
            if (cnt == (MUL2_DIV_CLK - 1))
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Generate div_clk_a based on updated counter
            // High for HIGH_COUNT cycles, low for LOW_COUNT cycles
            // Use the updated counter value for correct timing
            if (cnt < HIGH_COUNT)
                div_clk_a <= 1'b1;
            else
                div_clk_a <= 1'b0;
        end
    end

    // Generate div_clk_b on negedge clk by sampling stable div_clk_a
    always @(negedge clk) begin
        if (!rst_n) begin
            div_clk_b <= 1'b0;
        end else begin
            div_clk_b <= div_clk_a;
        end
    end

    // Final fractional divided clock is the OR of two phase-shifted clocks
    assign clk_div = div_clk_a | div_clk_b;

endmodule