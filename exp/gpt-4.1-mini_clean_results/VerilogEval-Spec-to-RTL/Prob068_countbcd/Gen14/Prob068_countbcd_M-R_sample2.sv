module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] digits [3:0]; // digits[0] = ones, digits[1] = tens, digits[2] = hundreds, digits[3] = thousands

    reg [3:0] next_digits [3:0];

    wire carry0, carry1, carry2;

    // Combinational logic for BCD increment with carries
    // Digit 0 (ones)
    assign carry0 = (digits[0] == 4'd9);
    assign next_digits[0] = carry0 ? 4'd0 : digits[0] + 4'd1;

    // Digit 1 (tens)
    assign carry1 = carry0 & (digits[1] == 4'd9);
    assign next_digits[1] = carry0 ? (carry1 ? 4'd0 : digits[1] + 4'd1) : digits[1];

    // Digit 2 (hundreds)
    assign carry2 = carry1 & (digits[2] == 4'd9);
    assign next_digits[2] = carry1 ? (carry2 ? 4'd0 : digits[2] + 4'd1) : digits[2];

    // Digit 3 (thousands)
    assign next_digits[3] = carry2 ? ((digits[3] == 4'd9) ? 4'd0 : digits[3] + 4'd1) : digits[3];

    // Enable signals: when lower digit is 9, upper digit increments
    assign ena[0] = carry0;
    assign ena[1] = carry1;
    assign ena[2] = carry2;

    // Sequential logic: update digits on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
        end else begin
            digits[0] <= next_digits[0];
            digits[1] <= next_digits[1];
            digits[2] <= next_digits[2];
            digits[3] <= next_digits[3];
        end
    end

    // Pack digits into output q
    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule