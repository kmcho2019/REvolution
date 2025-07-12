module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Carry signals for each digit
    wire carry_ones, carry_tens, carry_hundreds;

    // Determine if each digit will rollover (carry out)
    assign carry_ones     = (ones == 4'd9);
    assign carry_tens     = carry_ones     && (tens == 4'd9);
    assign carry_hundreds = carry_tens     && (hundreds == 4'd9);

    // Enable signals correspond to carry conditions for upper digits
    assign ena[0] = carry_ones;     // enable tens digit increment
    assign ena[1] = carry_tens;     // enable hundreds digit increment
    assign ena[2] = carry_hundreds; // enable thousands digit increment

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit with carry generation
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Increment tens digit if ones rolled over
            if (carry_ones) begin
                if (carry_tens)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Increment hundreds digit if tens rolled over
            if (carry_tens) begin
                if (carry_hundreds)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Increment thousands digit if hundreds rolled over
            if (carry_hundreds) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    // Concatenate digits into 16-bit BCD output
    assign q = {thousands, hundreds, tens, ones};

endmodule