module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    // MUL2_DIV_CLK = 7 (double the divisor for half-cycle control)
    localparam integer DIV_CNT_MAX = 7;

    // Two counters and clocks:
    // clk_p toggles on posedge, counts 4 cycles high, then 3 cycles low
    // clk_n toggles on negedge, same pattern but phase-shifted by half clk period

    // We define two counters: count_p for posedge domain, count_n for negedge domain
    // Each controls the duty cycle of clk_p and clk_n respectively.

    reg [2:0] count_p;   // 3 bits sufficient to count 0..6
    reg       clk_p;

    reg [2:0] count_n;
    reg       clk_n;

    // Posedge domain clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_p <= 3'd0;
            clk_p   <= 1'b0;
        end else begin
            // Counting uneven half cycles for clk_p:
            // When clk_p=0 (low), count cycles until 3 (3 clk cycles low)
            // When clk_p=1 (high), count cycles until 4 (4 clk cycles high)
            if (clk_p == 1'b0) begin
                // Low half: count 3 cycles (0..2)
                if (count_p == 3'd2) begin
                    clk_p   <= 1'b1;     // toggle high
                    count_p <= 3'd0;
                end else begin
                    count_p <= count_p + 3'd1;
                end
            end else begin
                // High half: count 4 cycles (0..3)
                if (count_p == 3'd3) begin
                    clk_p   <= 1'b0;     // toggle low
                    count_p <= 3'd0;
                end else begin
                    count_p <= count_p + 3'd1;
                end
            end
        end
    end

    // Negedge domain clock generation (phase shifted by half input clock)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_n <= 3'd0;
            clk_n   <= 1'b0;
        end else begin
            // Same pattern as clk_p, but offset by half clk cycle
            if (clk_n == 1'b0) begin
                // Low half: 3 cycles
                if (count_n == 3'd2) begin
                    clk_n   <= 1'b1;
                    count_n <= 3'd0;
                end else begin
                    count_n <= count_n + 3'd1;
                end
            end else begin
                // High half: 4 cycles
                if (count_n == 3'd3) begin
                    clk_n   <= 1'b0;
                    count_n <= 3'd0;
                end else begin
                    count_n <= count_n + 3'd1;
                end
            end
        end
    end

    // Final fractional clock is logical OR of clk_p and clk_n
    assign clk_div = clk_p | clk_n;

endmodule