module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    // Enable signals for upper digits
    // ena[0]: enable tens digit increment (when ones digit rolls over 9->0)
    // ena[1]: enable hundreds digit increment (when tens digit rolls over 9->0)
    // ena[2]: enable thousands digit increment (when hundreds digit rolls over 9->0)
    wire ena_ones_roll = (ones == 4'd9);
    wire ena_tens_roll = (tens == 4'd9);
    wire ena_hundreds_roll = (hundreds == 4'd9);

    assign ena[0] = ena_ones_roll;
    assign ena[1] = ena[0] & ena_tens_roll;
    assign ena[2] = ena[1] & ena_hundreds_roll;

    always @(posedge clk) begin
        if (reset) begin
            ones     <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            thousands<= 4'd0;
        end else begin
            // increment ones digit
            if (ones != 4'd9)
                ones <= ones + 1;
            else
                ones <= 4'd0;

            // increment tens digit if enabled by ones rollover
            if (ena[0]) begin
                if (tens != 4'd9)
                    tens <= tens + 1;
                else
                    tens <= 4'd0;
            end

            // increment hundreds digit if enabled by tens rollover
            if (ena[1]) begin
                if (hundreds != 4'd9)
                    hundreds <= hundreds + 1;
                else
                    hundreds <= 4'd0;
            end

            // increment thousands digit if enabled by hundreds rollover
            if (ena[2]) begin
                if (thousands != 4'd9)
                    thousands <= thousands + 1;
                else
                    thousands <= 4'd0;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule