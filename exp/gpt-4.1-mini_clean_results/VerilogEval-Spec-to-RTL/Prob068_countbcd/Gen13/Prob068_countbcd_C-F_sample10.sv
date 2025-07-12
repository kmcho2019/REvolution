module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Detect rollover conditions for each digit
    wire ones_rollover     = (ones == 4'd9);
    wire tens_rollover     = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    // Generate enable signals for tens, hundreds, thousands increments
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ena[1] & hundreds_rollover;

    // Carry signals propagate increment triggers upward
    wire carry_tens     = ones_rollover;
    wire carry_hundreds = carry_tens & tens_rollover;
    wire carry_thousands= carry_hundreds & hundreds_rollover;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Increment ones digit every clock
            if (ones_rollover)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Increment tens digit if carry from ones
            if (carry_tens) begin
                if (tens_rollover)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Increment hundreds digit if carry from tens
            if (carry_hundreds) begin
                if (hundreds_rollover)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Increment thousands digit if carry from hundreds
            if (carry_thousands) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    // Pack BCD digits into output bus
    assign q = {thousands, hundreds, tens, ones};

endmodule