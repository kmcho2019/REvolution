module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Carry (enable) signals indicate when each digit causes next digit to increment
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] & (tens == 4'd9);
    assign ena[2] = ena[1] & (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit with wrap-around at 9
            if (ones == 4'd9)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Increment tens if enabled (ones digit rolled over)
            if (ena[0]) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end

            // Increment hundreds if enabled (tens digit rolled over)
            if (ena[1]) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end

            // Increment thousands if enabled (hundreds digit rolled over)
            if (ena[2]) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule