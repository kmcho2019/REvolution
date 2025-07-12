module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    wire carry_ones;      // Carry from ones digit to tens
    wire carry_tens;      // Carry from tens digit to hundreds
    wire carry_hundreds;  // Carry from hundreds digit to thousands

    // Ones digit always increments
    assign carry_ones = (ones == 4'd9);

    // Tens digit increments only if carry from ones
    assign carry_tens = (tens == 4'd9) && carry_ones;

    // Hundreds digit increments only if carry from tens
    assign carry_hundreds = (hundreds == 4'd9) && carry_tens;

    // ena outputs: ena[0] = increment tens (carry from ones)
    //              ena[1] = increment hundreds (carry from tens)
    //              ena[2] = increment thousands (carry from hundreds)
    assign ena = {carry_hundreds, carry_tens, carry_ones};

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Increment tens digit if carry from ones
            if (carry_ones) begin
                if (carry_tens)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end

            // Increment hundreds digit if carry from tens
            if (carry_tens) begin
                if (carry_hundreds)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_hundreds) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end
        end
    end

    // Concatenate digits into output q
    assign q = {thousands, hundreds, tens, ones};

endmodule