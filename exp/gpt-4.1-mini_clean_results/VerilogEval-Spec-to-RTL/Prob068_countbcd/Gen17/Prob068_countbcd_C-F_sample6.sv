module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire carry_ones, carry_tens, carry_hundreds;

    // ena signals indicate when the next digit should be incremented
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Carry signals for each digit's overflow condition
    assign carry_ones     = (ones == 4'd9);
    assign carry_tens     = (tens == 4'd9)  && carry_ones;
    assign carry_hundreds = (hundreds == 4'd9) && carry_tens;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit always
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Increment tens digit if ones digit overflowed
            if (carry_tens)
                tens <= 4'd0;
            else if (carry_ones)
                tens <= tens + 4'd1;

            // Increment hundreds digit if tens digit overflowed
            if (carry_hundreds)
                hundreds <= 4'd0;
            else if (carry_tens)
                hundreds <= hundreds + 4'd1;

            // Increment thousands digit if hundreds digit overflowed
            if (carry_hundreds) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule