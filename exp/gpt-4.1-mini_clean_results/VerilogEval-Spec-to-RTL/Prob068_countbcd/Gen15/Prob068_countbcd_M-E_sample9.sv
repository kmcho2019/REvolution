module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // ena signals indicate when upper digit should increment:
    // When lower digit is at 9 (about to rollover next clock)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) & ena[0];
    assign ena[2] = (hundreds == 4'd9) & ena[1];

    // Concatenate output: thousands,tens,hundreds,ones
    assign q = {thousands, hundreds, tens, ones};

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit
            if (ones == 4'd9)
                ones <= 4'd0;
            else
                ones <= ones + 1;

            // Increment tens digit if ena[0] is asserted (ones just rolled over)
            if (ena[0]) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 1;
            end

            // Increment hundreds digit if ena[1] is asserted (tens just rolled over)
            if (ena[1]) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1;
            end

            // Increment thousands digit if ena[2] is asserted (hundreds just rolled over)
            if (ena[2]) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1;
            end
        end
    end

endmodule