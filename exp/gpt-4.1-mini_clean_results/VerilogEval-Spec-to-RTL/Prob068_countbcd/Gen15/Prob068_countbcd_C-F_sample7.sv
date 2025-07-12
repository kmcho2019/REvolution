module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0]: ones, digits[1]: tens, digits[2]: hundreds, digits[3]: thousands

    // Generate enable signals:
    // ena[0] when ones digit is 9 (next increment rolls over tens)
    // ena[1] when tens digit is 9 and ones digit is 9 (next increment rolls over hundreds)
    // ena[2] when hundreds digit is 9 and tens and ones digits are 9 (next increment rolls over thousands)
    assign ena[0] = (digits[0] == 4'd9);
    assign ena[1] = ena[0] && (digits[1] == 4'd9);
    assign ena[2] = ena[1] && (digits[2] == 4'd9);

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1)
                digits[i] <= 4'd0;
        end else begin
            // Ripple carry increment across digits
            // Start with carry_in = 1 (increment by 1)
            // For each digit:
            //  if carry_in and digit == 9, digit=0 carry_out=1 else digit=digit+carry_in carry_out=0
            reg carry_in;
            carry_in = 1'b1;
            for (i = 0; i < 4; i = i + 1) begin
                if (carry_in) begin
                    if (digits[i] == 4'd9) begin
                        digits[i] <= 4'd0;
                        carry_in = 1'b1; // carry propagate
                    end else begin
                        digits[i] <= digits[i] + 4'd1;
                        carry_in = 1'b0; // no carry, done
                    end
                end
                else begin
                    // No carry in, no change
                    digits[i] <= digits[i];
                end
            end
        end
    end

    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule