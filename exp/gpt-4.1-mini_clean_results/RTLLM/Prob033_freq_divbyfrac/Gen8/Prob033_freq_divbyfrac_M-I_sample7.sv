module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;

    // Counter counts 0 to 6 (7 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // clk_intA: high for 4 clock cycles (counter 0 to 3)
    wire clk_intA = (counter <= 3'd3);

    // clk_intB combinational: high for 3 clock cycles (counter 0 to 2)
    wire clk_intB_comb = (counter <= 3'd2);

    // Register clk_intB on posedge clk
    reg clk_intB_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_pos <= 1'b0;
        else
            clk_intB_pos <= clk_intB_comb;
    end

    // Register clk_intB on negedge clk (half-cycle shifted version)
    reg clk_intB_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_neg <= 1'b0;
        else
            clk_intB_neg <= clk_intB_comb;
    end

    // Final fractional clock: OR of clk_intA and half-cycle shifted clk_intB_neg
    assign clk_div = clk_intA | clk_intB_neg;

endmodule