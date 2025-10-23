module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Rollover detection for each digit
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);

    // Enable signals for digits 3:1 increments
    assign ena[0] = ones_rollover;                           // tens enable
    assign ena[1] = ones_rollover & tens_rollover;           // hundreds enable
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover; // thousands enable

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
                ones <= ones + 4'd1;

            // Increment tens digit on ones rollover
            if (ones_rollover) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Increment hundreds digit on tens and ones rollover
            if (ena[1]) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Increment thousands digit on hundreds, tens, and ones rollover
            if (ena[2]) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    // Combine digits to form output
    assign q = {thousands, hundreds, tens, ones};

endmodule