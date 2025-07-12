module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Function to increment a BCD digit with carry out
    function [4:0] bcd_increment;
        input [3:0] digit_in;
    begin
        if (digit_in == 4'd9)
            bcd_increment = {1'b1, 4'd0}; // carry = 1, digit reset to 0
        else
            bcd_increment = {1'b0, digit_in + 1'b1}; // carry = 0, digit + 1
    end
    endfunction

    // Generate enable signals indicating when each upper digit should increment:
    // ena[0]: increment tens when ones is 9 before increment (ones will roll over)
    // ena[1]: increment hundreds when tens is 9 and tens increment enabled
    // ena[2]: increment thousands when hundreds is 9 and hundreds increment enabled
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            reg carry_ones, carry_tens, carry_hundreds, carry_thousands;
            reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;

            {carry_ones, ones_next} = bcd_increment(ones);

            if (carry_ones) begin
                {carry_tens, tens_next} = bcd_increment(tens);
                if (carry_tens) begin
                    {carry_hundreds, hundreds_next} = bcd_increment(hundreds);
                    if (carry_hundreds) begin
                        {carry_thousands, thousands_next} = bcd_increment(thousands);
                        thousands <= thousands_next;
                    end else begin
                        thousands_next = thousands; // no change
                        thousands <= thousands_next;
                    end
                    hundreds <= hundreds_next;
                end else begin
                    hundreds_next = hundreds; // no change
                    hundreds <= hundreds_next;
                    tens <= tens_next;
                end
                tens <= tens_next;
            end else begin
                tens_next = tens; // no change
                tens <= tens_next;
            end

            ones <= ones_next;
        end
    end

    // Pack digits into output vector
    assign q = {thousands, hundreds, tens, ones};

endmodule