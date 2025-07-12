module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    // Counter cycles from 0 to 6 (7 cycles total)
    reg [2:0] counter_pos; // Counter for posedge domain
    reg [2:0] counter_neg; // Counter for negedge domain

    // Intermediate clocks generated on posedge and negedge of clk
    reg clk_intA;  // Clock generated on posedge clk
    reg clk_intB;  // Clock generated on negedge clk (phase shifted by half clk period)

    // -------- Positive edge logic --------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_pos <= 3'd0;
            clk_intA <= 1'b0;
        end else begin
            if (counter_pos == 3'd6)
                counter_pos <= 3'd0;
            else
                counter_pos <= counter_pos + 3'd1;

            // Generate clk_intA with 4-cycle high and 3-cycle low per 7-cycle period:
            // clk_intA is high for counter_pos: 0,1,2,3 (4 cycles)
            // low for 4,5,6 (3 cycles)
            if (counter_pos <= 3'd3)
                clk_intA <= 1'b1;
            else
                clk_intA <= 1'b0;
        end
    end

    // -------- Negative edge logic --------
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_neg <= 3'd0;
            clk_intB <= 1'b0;
        end else begin
            if (counter_neg == 3'd6)
                counter_neg <= 3'd0;
            else
                counter_neg <= counter_neg + 3'd1;

            // Generate clk_intB with 3-cycle high and 4-cycle low per 7-cycle period:
            // clk_intB is high for counter_neg: 0,1,2 (3 cycles)
            // low for 3,4,5,6 (4 cycles)
            if (counter_neg <= 3'd2)
                clk_intB <= 1'b1;
            else
                clk_intB <= 1'b0;
        end
    end

    // Final fractional divided clock output by OR-ing both intermediate clocks
    assign clk_div = clk_intA | clk_intB;

endmodule