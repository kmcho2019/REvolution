module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals indicate when the next digit should increment:
    // ena[0] enables tens when ones digit rolls over (is 9),
    // ena[1] enables hundreds when tens digit rolls over, and so on.
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Function to increment a BCD digit and output carry flag if digit rolls over
    function [4:0] bcd_increment;
        input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_increment = {1'b1, 4'd0}; // carry out = 1, digit resets to 0
        else
            bcd_increment = {1'b0, digit + 4'd1}; // no carry, digit+1
    end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            reg [4:0] ones_next, tens_next, hundreds_next, thousands_next;

            ones_next = bcd_increment(ones);

            // Start carry propagation if ones digit rolled over
            if (ones_next[4]) begin
                tens_next = bcd_increment(tens);

                if (tens_next[4]) begin
                    hundreds_next = bcd_increment(hundreds);

                    if (hundreds_next[4]) begin
                        thousands_next = bcd_increment(thousands);
                        thousands <= thousands_next[3:0];
                    end else begin
                        thousands_next = {1'b0, thousands};
                        thousands <= thousands; // unchanged
                    end

                    hundreds <= hundreds_next[3:0];
                end else begin
                    hundreds_next = {1'b0, hundreds};
                    hundreds <= hundreds; // unchanged
                end

                tens <= tens_next[3:0];
            end else begin
                tens_next = {1'b0, tens};
                tens <= tens; // unchanged
                hundreds <= hundreds; // unchanged
                thousands <= thousands; // unchanged
            end

            ones <= ones_next[3:0];
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule