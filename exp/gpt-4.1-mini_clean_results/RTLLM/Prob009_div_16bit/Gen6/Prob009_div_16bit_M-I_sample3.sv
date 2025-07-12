module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (zero-extended)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division process
    always @(*) begin
        reg [8:0] remainder;        // 9-bit remainder to hold shifted bits without overflow
        reg [15:0] quotient;
        integer i;

        remainder = 9'd0;
        quotient = 16'd0;

        // Iterate from MSB (bit 15) down to LSB (bit 0)
        // At each step:
        // - shift remainder left by 1, concatenate current bit of dividend
        // - if remainder >= divisor, subtract divisor and set quotient bit
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], a_reg[i]}; // shift left by 1 and append A[i]

            if (remainder[8:1] >= b_reg) begin
                remainder[8:1] = remainder[8:1] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
            // remainder[0] remains as is (just the appended bit), will be shifted next iteration
        end

        result = quotient;
        // remainder[8:1] is the 8-bit remainder after final subtraction
        odd = {8'd0, remainder[8:1]};
    end
endmodule