module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter counts from 0 to 6 (7 states) to generate the 3.5 division cycle
    reg [2:0] counter;

    // Increment counter modulo 7 on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // Generate clk_pos with period 7 clk cycles:
    // High for 4 cycles (counter 0..3), low for 3 cycles (4..6)
    wire clk_pos = (counter <= 3'd3);

    // Generate clk_neg similarly but phase shifted by +1 count to simulate half clk delay
    // This mimics the phase shift of half a clk cycle (i.e. toggling at negedge)
    // Use (counter + 1) mod 7 for phase shift
    wire [2:0] counter_shift = (counter == 3'd6) ? 3'd0 : (counter + 3'd1);
    wire clk_neg = (counter_shift <= 3'd3);

    // XOR the two phase-shifted signals to get fractional divide-by-3.5 clk
    assign clk_div = clk_pos ^ clk_neg;

endmodule