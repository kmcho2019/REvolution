module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;

    // Counter counts from 0 to 6 (7 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // clk_intA: high for 4 clock cycles (counts 0 to 3)
    wire clk_intA = (counter <= 3'd3);

    // clk_intB: high for 3 clock cycles (counts 0 to 2)
    wire clk_intB = (counter <= 3'd2);

    // Generate half-cycle delayed clk_intB by gating with inverted clk
    wire clk_intB_shift = clk_intB & (~clk);

    // Final fractional clock: OR of clk_intA and half-cycle shifted clk_intB
    assign clk_div = clk_intA | clk_intB_shift;

endmodule