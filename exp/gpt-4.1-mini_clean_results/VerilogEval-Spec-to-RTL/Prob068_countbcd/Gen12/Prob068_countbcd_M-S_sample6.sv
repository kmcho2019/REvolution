module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Generate enable signals for upper digits
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
            // Increment ones digit always
            if (ones == 4'd9)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Increment tens digit when ena[0] is high
            if (ena[0]) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end

            // Increment hundreds digit when ena[1] is high
            if (ena[1]) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end

            // Increment thousands digit when ena[2] is high
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