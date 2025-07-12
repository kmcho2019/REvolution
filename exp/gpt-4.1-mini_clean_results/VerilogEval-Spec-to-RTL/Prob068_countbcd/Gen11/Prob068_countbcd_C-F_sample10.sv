module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Rollover signals for each digit (indicate digit == 9)
    wire ones_rollover     = (ones == 4'd9);
    wire tens_rollover     = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    // Enable signals for upper digits increment: 
    // tens increments when ones rolls over
    // hundreds increments when tens and ones roll over
    // thousands increments when hundreds, tens, and ones roll over
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ena[1] & hundreds_rollover;

    // Inline increment function: wrap from 9 to 0
    function [3:0] inc_bcd;
        input [3:0] digit;
        begin
            inc_bcd = (digit == 4'd9) ? 4'd0 : digit + 4'd1;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones every cycle
            ones <= inc_bcd(ones);

            // Increment tens if enabled
            if (ena[0])
                tens <= inc_bcd(tens);

            // Increment hundreds if enabled
            if (ena[1])
                hundreds <= inc_bcd(hundreds);

            // Increment thousands if enabled
            if (ena[2])
                thousands <= inc_bcd(thousands);
        end
    end

    // Pack the digits into q output as BCD digits
    assign q = {thousands, hundreds, tens, ones};

endmodule