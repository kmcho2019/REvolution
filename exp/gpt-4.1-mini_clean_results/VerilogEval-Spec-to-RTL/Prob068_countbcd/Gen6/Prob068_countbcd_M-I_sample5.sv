module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);
    // Separate 4-bit registers for each BCD digit
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Detect rollover: digit == 9, next increment causes carry
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    // Generate enables for upper digits:
    // tens increments when ones rolls over
    // hundreds increments when tens rolls over and ones rolls over
    // thousands increments when hundreds, tens, and ones roll over
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover;

    // Increment digit function: returns incremented digit (wraps from 9->0)
    function [3:0] inc_bcd;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                inc_bcd = 4'd0;
            else
                inc_bcd = digit + 4'd1;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands<= 4'd0;
        end else begin
            // Increment ones every cycle
            ones <= inc_bcd(ones);

            // Conditionally increment tens only when ones rolled over
            if (ones_rollover)
                tens <= inc_bcd(tens);

            // Conditionally increment hundreds only when tens and ones rolled over
            if (ena[1]) // ones_rollover & tens_rollover
                hundreds <= inc_bcd(hundreds);

            // Conditionally increment thousands only when hundreds, tens, and ones rolled over
            if (ena[2]) // ones_rollover & tens_rollover & hundreds_rollover
                thousands <= inc_bcd(thousands);
        end
    end

    // Concatenate digits to form 16-bit output
    assign q = {thousands, hundreds, tens, ones};

endmodule