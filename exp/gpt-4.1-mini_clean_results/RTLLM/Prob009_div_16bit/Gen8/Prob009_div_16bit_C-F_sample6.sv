module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Latch inputs into internal registers for stable inputs in combinational logic
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational restoring division algorithm
    always @(*) begin
        integer i;
        reg [8:0] remainder;     // 9-bit remainder: 1 extra bit + 8-bit divisor width
        reg [15:0] quotient;     // 16-bit quotient result
        reg [8:0] divisor_ext;   // 9-bit zero-extended divisor for direct comparison

        remainder = 9'b0;
        quotient  = 16'b0;
        divisor_ext = {1'b0, b_reg}; // zero-extend divisor to 9 bits

        // Iterate from most significant bit to least of dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};

            // If remainder >= divisor, subtract divisor and set quotient bit
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Output remainder zero-extended from lower 8 bits of remainder to 16 bits
        odd = {8'b0, remainder[7:0]};
    end

endmodule