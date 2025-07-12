module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] digits; // 4 BCD digits: {thousands, hundreds, tens, ones}

    // Extract digit slices for convenience
    wire [3:0] ones     = digits[3:0];
    wire [3:0] tens     = digits[7:4];
    wire [3:0] hundreds = digits[11:8];
    wire [3:0] thousands= digits[15:12];

    // Generate enable signals indicating when to increment next digit
    // Enable if current digit equals 9 (about to roll over after increment)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) && ena[0];
    assign ena[2] = (hundreds == 4'd9) && ena[1];

    always @(posedge clk) begin
        if (reset) begin
            digits <= 16'd0;
        end else begin
            reg [15:0] next_digits;
            integer i;
            reg carry;

            next_digits = digits;
            carry = 1'b1; // start increment by 1 for ones digit

            // Manually unrolled loop over 4 digits: ones, tens, hundreds, thousands
            // Increment digit if carry-in is set, generate carry-out if digit rolls over from 9
            for (i = 0; i < 4; i = i + 1) begin
                reg [3:0] current_digit;
                reg [3:0] incremented;

                current_digit = next_digits[i*4 +: 4];
                if (carry) begin
                    if (current_digit == 4'd9) begin
                        incremented = 4'd0;
                        carry = 1'b1;
                    end else begin
                        incremented = current_digit + 4'd1;
                        carry = 1'b0;
                    end
                    next_digits[i*4 +:4] = incremented;
                end
            end

            digits <= next_digits;
        end
    end

    assign q = digits;

endmodule