module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands
    wire c0, c1, c2;        // Carry signals indicating digit == 9

    // Carry signals: digit equals 9 means next digit increments
    assign c0 = (digits[0] == 4'd9);
    assign c1 = c0 & (digits[1] == 4'd9);
    assign c2 = c1 & (digits[2] == 4'd9);

    // Enable signals: when each upper digit should be incremented
    assign ena[0] = c0;
    assign ena[1] = c1;
    assign ena[2] = c2;

    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            // Increment ones digit and generate ripple carry increments in parallel style
            if (c0)
                digits[0] <= 4'd0;
            else
                digits[0] <= digits[0] + 1;

            if (c0) begin
                if (c1)
                    digits[1] <= 4'd0;
                else
                    digits[1] <= digits[1] + 1;
            end

            if (c1) begin
                if (c2)
                    digits[2] <= 4'd0;
                else
                    digits[2] <= digits[2] + 1;
            end

            if (c2) begin
                digits[3] <= (digits[3] == 4'd9) ? 4'd0 : digits[3] + 1;
            end
        end
    end

    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule