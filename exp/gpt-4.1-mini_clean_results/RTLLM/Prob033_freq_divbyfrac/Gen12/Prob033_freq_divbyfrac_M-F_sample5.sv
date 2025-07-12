module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_MOD = 7; // Divider modulus (7 cycles for one full cycle of divided clk)
    localparam OFFSET = 4;  // Offset for phase shift of clk_intB (half-cycle shift)

    reg [2:0] counter_A; // Counter for clk_intA (0..6)
    reg [2:0] counter_B; // Counter for clk_intB (offset by 4 modulo 7)

    reg clk_intA;
    reg clk_intB;

    // Counter and clk_intA generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_A <= 3'd0;
            clk_intA  <= 1'b0;
        end else begin
            if (counter_A == DIV_MOD - 1)
                counter_A <= 3'd0;
            else
                counter_A <= counter_A + 3'd1;

            // clk_intA is high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            clk_intA <= (counter_A < 4) ? 1'b1 : 1'b0;
        end
    end

    // Counter and clk_intB generation with offset to create half-cycle phase shift
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_B <= OFFSET % DIV_MOD;
            clk_intB  <= 1'b0;
        end else begin
            if (counter_B == DIV_MOD - 1)
                counter_B <= 3'd0;
            else
                counter_B <= counter_B + 3'd1;

            // clk_intB is high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            clk_intB <= (counter_B < 4) ? 1'b1 : 1'b0;
        end
    end

    // Final output is OR of clk_intA and clk_intB to create fractional frequency divider by 3.5
    assign clk_div = clk_intA | clk_intB;

endmodule