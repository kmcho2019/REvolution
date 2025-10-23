module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Combinational block performs restoring division
    // remainder: 9-bit register (1 bit extra for carry during shifts)
    // divisor_ext: divisor zero-extended to 9 bits
    // Loop from MSB to LSB, shift in dividend bits into remainder,
    // subtract divisor if possible, set quotient bit accordingly.
    always @(*) begin
        integer i;
        reg [8:0] remainder;
        reg [15:0] quotient;
        reg [8:0] divisor_ext;

        remainder = 9'd0;
        quotient = 16'd0;
        divisor_ext = {1'b0, B};  // Extend divisor to 9 bits

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], A[i]}; // Shift left and bring down dividend bit
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder[7:0]}; // Zero-extend remainder to 16 bits
    end

endmodule