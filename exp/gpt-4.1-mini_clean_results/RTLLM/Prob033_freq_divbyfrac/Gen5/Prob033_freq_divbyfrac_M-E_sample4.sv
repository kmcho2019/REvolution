module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    // Counter cycles from 0 to 6 (7 cycles total)
    reg [2:0] counter;

    // Intermediate pulse signals generated synchronously
    reg clk_intA; // Pulse high for 4 clk cycles per 7-cycle period
    reg clk_intB; // Pulse high for 3 clk cycles per 7-cycle period

    // Phase shifted version of clk_intB by sampling on negedge clk
    reg clk_intB_phase_shift;

    // -------- Counter and clk_intA, clk_intB generation --------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'd0;
            clk_intA <= 1'b0;
            clk_intB <= 1'b0;
        end else begin
            // Increment counter modulo 7
            if (counter == 3'd6)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;

            // clk_intA: high for counter 0..3 (4 cycles), low otherwise (3 cycles)
            if (counter <= 3'd3)
                clk_intA <= 1'b1;
            else
                clk_intA <= 1'b0;

            // clk_intB: high for counter 0..2 (3 cycles), low otherwise (4 cycles)
            if (counter <= 3'd2)
                clk_intB <= 1'b1;
            else
                clk_intB <= 1'b0;
        end
    end

    // -------- Phase shift clk_intB by half clock using negedge clk --------
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_phase_shift <= 1'b0;
        else
            clk_intB_phase_shift <= clk_intB;
    end

    // -------- Final fractional divided clock --------
    // OR of clk_intA and phase shifted clk_intB produces 3.5 division with smooth duty cycle
    assign clk_div = clk_intA | clk_intB_phase_shift;

endmodule