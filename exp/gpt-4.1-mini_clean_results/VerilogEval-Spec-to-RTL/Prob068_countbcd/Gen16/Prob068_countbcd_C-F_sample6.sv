module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals combinationally indicate when each upper digit should increment:
    // ena[0] enables tens when ones digit is 9 (rolling over next cycle)
    // ena[1] enables hundreds when tens digit is 9 and ones digit is rolling over
    // ena[2] enables thousands when hundreds digit is 9 and previous digits rolling over
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Reusable BCD increment function: returns {carry, incremented_digit}
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0};  // carry out, digit rolls over to 0
            else
                bcd_increment = {1'b0, digit + 1'b1};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            reg [4:0] inc_ones, inc_tens, inc_hundreds, inc_thousands;

            // Increment ones digit unconditionally every clock cycle
            inc_ones = bcd_increment(ones);
            ones <= inc_ones[3:0];

            // Propagate carry to tens only if ones digit rolled over
            if (inc_ones[4]) begin
                inc_tens = bcd_increment(tens);
                tens <= inc_tens[3:0];

                // Propagate carry to hundreds only if tens rolled over
                if (inc_tens[4]) begin
                    inc_hundreds = bcd_increment(hundreds);
                    hundreds <= inc_hundreds[3:0];

                    // Propagate carry to thousands only if hundreds rolled over
                    if (inc_hundreds[4]) begin
                        inc_thousands = bcd_increment(thousands);
                        thousands <= inc_thousands[3:0];
                    end
                end
            end
            // If no carry, upper digits remain unchanged (no else needed because of non-blocking assignments)
        end
    end

    // Concatenate digits for output as [thousands][hundreds][tens][ones]
    assign q = {thousands, hundreds, tens, ones};

endmodule