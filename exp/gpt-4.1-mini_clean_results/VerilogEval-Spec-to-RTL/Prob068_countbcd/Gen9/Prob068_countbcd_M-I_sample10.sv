module TopModule (
    input         clk,
    input         reset,
    output reg [2:0] ena,
    output [15:0] q
);
    // Separate 4-bit registers for each BCD digit
    reg [3:0] ones, tens, hundreds, thousands;

    // Detect rollover conditions for each digit
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    // Ripple carry enable generation to reduce combinational depth:
    // ena[0]: tens enable = ones_rollover
    // ena[1]: hundreds enable = tens_rollover & ena[0]
    // ena[2]: thousands enable = hundreds_rollover & ena[1]
    wire ena0_next = ones_rollover;
    wire ena1_next = tens_rollover & ena0_next;
    wire ena2_next = hundreds_rollover & ena1_next;

    // Increment logic for a BCD digit: explicit combinational increment with wrap-around
    function [3:0] inc_bcd_explicit;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                inc_bcd_explicit = 4'd0;
            else
                inc_bcd_explicit = digit + 4'd1;
        end
    endfunction

    // Registers for outputs and enable signals
    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands<= 4'd0;
            ena      <= 3'b0;
        end else begin
            // Register enables to reduce glitches and ensure stable enable signals during clock cycle
            ena <= {ena2_next, ena1_next, ena0_next};

            // Increment ones digit unconditionally each cycle
            ones <= inc_bcd_explicit(ones);

            // Increment tens digit when ena[0] (ones rolled over)
            if (ena0_next)
                tens <= inc_bcd_explicit(tens);

            // Increment hundreds digit when ena[1] (tens and ones rolled over)
            if (ena1_next)
                hundreds <= inc_bcd_explicit(hundreds);

            // Increment thousands digit when ena[2] (hundreds, tens, ones rolled over)
            if (ena2_next)
                thousands <= inc_bcd_explicit(thousands);
        end
    end

    // Concatenate digits for output
    assign q = {thousands, hundreds, tens, ones};

endmodule