module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided clock output (divide by 3.5)
);

    // Single free-running counter from 0 to 6
    reg [2:0] cnt;

    // Registered delayed version of clk_intA to generate phase-shifted clk_intB
    reg clk_intA_reg;
    reg clk_delayed; // delayed version of clk_intA_reg by 1 half cycle simulated via clk crossing

    // Counter logic: counts 0 to 6 repeatedly on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == 3'd6)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_intA is high for counts 0 to 3 (4 cycles), low otherwise
    wire clk_intA = (cnt <= 3'd3) ? 1'b1 : 1'b0;

    // Register clk_intA at clk rising edge to get stable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA_reg <= 1'b0;
        else
            clk_intA_reg <= clk_intA;
    end

    // Generate delayed clk_intA (clk_delayed) using a negative-edge flip-flop effect
    // Implement half-cycle phase shift: latch clk_intA_reg at negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_delayed <= 1'b0;
        else
            clk_delayed <= clk_intA_reg;
    end

    // clk_intB generated on negedge clk phase-shifted by half clock cycle:
    // Using delayed clk_intA with different high period (counts 3 to 5, 3 cycles)
    // We approximate this by gating clk_delayed with count window 3-5.
    wire clk_intB = ((cnt >= 3'd3) && (cnt <= 3'd5)) ? clk_delayed : 1'b0;

    // Final fractional divided clock is OR of clk_intA and clk_intB
    assign clk_div = clk_intA | clk_intB;

endmodule