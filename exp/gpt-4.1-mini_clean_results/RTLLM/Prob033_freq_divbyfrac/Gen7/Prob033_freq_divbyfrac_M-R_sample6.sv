module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low asynchronous reset
    output wire clk_div // Fractionally divided clock output (divide by 3.5)
);

    // Parameters defining the fractional division:
    // 3.5 division -> cycle length = 7 clk cycles (MUL2_DIV_CLK = 7)
    localparam CNT_MAX = 3'd6; // Counter max value (0 to 6)

    reg [2:0] counter;           // 3-bit counter: counts 0 to 6
    reg       clk_intB_phase_shift; // Phase-shifted clk_intB sampled at negedge clk

    // Counter increments on positive edge of clk with async active low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == CNT_MAX)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // Generate clk_intA: HIGH for counter = 0 to 3 (4 cycles)
    wire clk_intA = (counter <= 3'd3);

    // Generate clk_intB: HIGH for counter = 0 to 2 (3 cycles)
    wire clk_intB = (counter <= 3'd2);

    // Sample clk_intB at negedge clk for half-cycle phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_phase_shift <= 1'b0;
        else
            clk_intB_phase_shift <= clk_intB;
    end

    // Final fractional divided clock by ORing clk_intA and half-cycle shifted clk_intB
    assign clk_div = clk_intA | clk_intB_phase_shift;

endmodule