module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;
    reg clk_intB_negedge; // clk_intB sampled on negedge clk

    // Counter counts from 0 to 6 (7 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // clk_intA: high for counts 0 to 3 (4 cycles)
    wire clk_intA = (counter <= 3'd3);

    // clk_intB: high for counts 4 to 6 (3 cycles)
    wire clk_intB = (counter >= 3'd4);

    // Sample clk_intB at negedge of clk to create half-cycle phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_negedge <= 1'b0;
        else
            clk_intB_negedge <= clk_intB;
    end

    // Final fractional clock output: OR of clk_intA and negedge-sampled clk_intB
    assign clk_div = clk_intA | clk_intB_negedge;

endmodule