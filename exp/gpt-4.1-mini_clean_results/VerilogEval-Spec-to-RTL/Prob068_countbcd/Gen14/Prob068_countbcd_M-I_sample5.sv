module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire      carry_ones, carry_tens, carry_hundreds;

    // Carry occurs when digit == 9 before increment
    assign carry_ones     = (ones == 4'd9);
    assign carry_tens     = carry_ones && (tens == 4'd9);
    assign carry_hundreds = carry_tens && (hundreds == 4'd9);

    // Enable signals are asserted when lower digit(s) roll over
    assign ena[0] = carry_ones;       // Enable tens increment when ones roll over
    assign ena[1] = carry_tens;       // Enable hundreds increment when tens roll over
    assign ena[2] = carry_hundreds;   // Enable thousands increment when hundreds roll over

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Calculate next digit values and apply carry increments in parallel
            // Ones digit increment with rollover
            if (carry_ones)
                ones <= 4'd0;
            else
                ones <= ones + 1'b1;

            // Tens digit increment if ones roll over
            if (carry_ones) begin
                if (carry_tens)
                    tens <= 4'd0;
                else
                    tens <= tens + 1'b1;
            end else begin
                tens <= tens;
            end

            // Hundreds digit increment if tens roll over
            if (carry_tens) begin
                if (carry_hundreds)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 1'b1;
            end else begin
                hundreds <= hundreds;
            end

            // Thousands digit increment if hundreds roll over
            if (carry_hundreds) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 1'b1;
            end else begin
                thousands <= thousands;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule