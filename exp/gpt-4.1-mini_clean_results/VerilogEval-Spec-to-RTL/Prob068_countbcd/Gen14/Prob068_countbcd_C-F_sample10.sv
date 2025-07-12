module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Carry signals: indicate when each digit increments the next digit
    wire carry_ones = (ones == 4'd9);
    wire carry_tens = carry_ones && (tens == 4'd9);
    wire carry_hundreds = carry_tens && (hundreds == 4'd9);

    // Enable signals: when each upper digit should increment
    assign ena[0] = carry_ones;
    assign ena[1] = carry_tens;
    assign ena[2] = carry_hundreds;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit and generate carry out
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

    assign q = {thousands, hundreds, tens, ones};

endmodule