module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    // Counter running on posedge clk: counts 0..6
    reg [2:0] counter_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter_pos <= 3'd0;
        else if (counter_pos == 3'd6)
            counter_pos <= 3'd0;
        else
            counter_pos <= counter_pos + 3'd1;
    end

    // Counter running on negedge clk: counts 0..6
    reg [2:0] counter_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            counter_neg <= 3'd0;
        else if (counter_neg == 3'd6)
            counter_neg <= 3'd0;
        else
            counter_neg <= counter_neg + 3'd1;
    end

    // clk_intA is high for counts 0 to 3 on posedge counter (4 cycles)
    wire clk_intA = (counter_pos <= 3'd3);

    // clk_intB is high for counts 0 to 2 on negedge counter (3 cycles)
    wire clk_intB = (counter_neg <= 3'd2);

    // Fractional clock is OR of clk_intA and clk_intB (phase shifted by half clk)
    assign clk_div = clk_intA | clk_intB;

endmodule