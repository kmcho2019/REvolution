module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;
    reg clk_intA;
    reg clk_intB_pos;
    reg clk_intB_neg;
    reg [2:0] counter_posedge; // To hold counter value for negedge clk sampling

    // Counter and clk_intA, clk_intB_pos update on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'd0;
            clk_intA <= 1'b0;
            clk_intB_pos <= 1'b0;
            counter_posedge <= 3'd0;
        end else begin
            // Counter cycles 0 to 6
            if (counter == 3'd6)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;

            // Store counter value to use on negedge clk for clk_intB_neg generation
            counter_posedge <= counter;

            // clk_intA high for counts 0 to 3 (4 cycles)
            clk_intA <= (counter <= 3'd3);

            // clk_intB_pos high for counts 0 to 2 (3 cycles)
            clk_intB_pos <= (counter <= 3'd2);
        end
    end

    // clk_intB_neg update on negedge clk based on stored counter_posedge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_neg <= 1'b0;
        else
            clk_intB_neg <= (counter_posedge <= 3'd2);
    end

    // Final output clock: OR of clk_intA and half-cycle shifted clk_intB_neg
    assign clk_div = clk_intA | clk_intB_neg;

endmodule