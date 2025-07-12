module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Generate enables for tens, hundreds, thousands based on current digit values
    // ena[0] - enable tens increment (when ones == 9)
    // ena[1] - enable hundreds increment (when tens == 9 and ena[0] asserted)
    // ena[2] - enable thousands increment (when hundreds == 9 and ena[1] asserted)
    wire ena_ones = 1'b1; // ones always increments
    wire ena_tens = (ones == 4'd9);
    wire ena_hundreds = (tens == 4'd9) && ena_tens;
    wire ena_thousands = (hundreds == 4'd9) && ena_hundreds;

    assign ena = {ena_thousands, ena_hundreds, ena_tens};

    // Sequential logic updates digits only when enabled
    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Update ones digit
            if (ones == 4'd9)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;

            // Update tens digit
            if (ena_tens) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end

            // Update hundreds digit
            if (ena_hundreds) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end

            // Update thousands digit
            if (ena_thousands) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end

    // Output concatenated BCD digits
    assign q = {thousands, hundreds, tens, ones};

endmodule