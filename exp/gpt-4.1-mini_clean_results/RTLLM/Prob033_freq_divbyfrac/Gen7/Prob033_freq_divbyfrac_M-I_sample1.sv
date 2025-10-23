module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;

    // Combinational signals derived directly from counter value
    wire clk_intA;
    wire clk_intB;

    // clk_intB_phase_shift: clk_intB delayed by half clock cycle using negedge clk
    reg clk_intB_phase_shift;

    // Counter increments at posedge clk, counts 0 to 6 (7 states for division by 3.5)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // clk_intA: high for 4 cycles (counter = 0..3)
    assign clk_intA = (counter <= 3'd3);

    // clk_intB: high for 3 cycles (counter = 0..2)
    assign clk_intB = (counter <= 3'd2);

    // Phase shift clk_intB by sampling it at negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_phase_shift <= 1'b0;
        else
            clk_intB_phase_shift <= clk_intB;
    end

    // Final divided clock is OR of clk_intA and half-cycle delayed clk_intB
    assign clk_div = clk_intA | clk_intB_phase_shift;

endmodule