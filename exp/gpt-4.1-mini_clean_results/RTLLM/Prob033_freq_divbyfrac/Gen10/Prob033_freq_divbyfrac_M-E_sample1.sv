module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] cnt;

    // Generate intermediate clocks based on counter
    // clk_intA: High for counts 0 to 3 (4 cycles)
    wire clk_intA = (cnt <= 3'd3);
    // clk_intB: High for counts 4 to 6 (3 cycles)
    wire clk_intB = (cnt >= 3'd4);

    // Sample clk_intA and clk_intB on posedge and negedge of clk
    reg clk_intA_negedge, clk_intB_negedge;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == 3'd6)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_intA_negedge <= 1'b0;
            clk_intB_negedge <= 1'b0;
        end else begin
            clk_intA_negedge <= clk_intA;
            clk_intB_negedge <= clk_intB;
        end
    end

    // Create two phase-shifted clocks by combining posedge and negedge sampled intermediate clocks
    wire phaseA = clk_intA | clk_intA_negedge;  // phaseA toggles every half cycle based on clk_intA
    wire phaseB = clk_intB | clk_intB_negedge;  // phaseB toggles every half cycle based on clk_intB

    // Final fractional output clock is OR of the two phased clocks
    // This produces a waveform with uniform period (7 half-cycles = 3.5 full cycles)
    assign clk_div = phaseA | phaseB;

endmodule