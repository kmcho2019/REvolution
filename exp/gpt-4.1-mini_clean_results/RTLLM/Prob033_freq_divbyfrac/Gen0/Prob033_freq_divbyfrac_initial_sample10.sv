module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5
    localparam integer MUL2_DIV_CLK = 7;  // 3.5 * 2
    localparam integer HIGH_COUNT   = 4;  // High period in clk cycles
    localparam integer LOW_COUNT    = 3;  // Low period in clk cycles

    reg [2:0] cnt;          // 3-bit counter for counting 0 to 6
    reg       div_clk_a;    // Divided clock - phase A
    reg       div_clk_b;    // Divided clock - phase B (phase shifted)

    // Counter increments on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            div_clk_a <= 1'b0;
        end else begin
            if (cnt == (MUL2_DIV_CLK - 1))
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Generate div_clk_a:
            // Output high when cnt < HIGH_COUNT (4 cycles),
            // low otherwise (3 cycles)
            div_clk_a <= (cnt < HIGH_COUNT) ? 1'b1 : 1'b0;
        end
    end

    // Generate div_clk_b by sampling div_clk_a on negative edge of clk,
    // achieving a half cycle phase shift (delay by half clk period)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_clk_b <= 1'b0;
        end else begin
            div_clk_b <= div_clk_a;
        end
    end

    // Final fractional divided clock is OR of the two phase-shifted clocks
    assign clk_div = div_clk_a | div_clk_b;

endmodule