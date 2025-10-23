module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Input latching registers (combinational, as requested)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic using restoring division algorithm
    always @(*) begin
        integer i;
        reg [8:0] remainder;      // 9-bit remainder to hold shifted bits and carry
        reg [15:0] quotient;      // 16-bit quotient
        reg [8:0] divisor_ext;    // 9-bit zero-extended divisor

        remainder   = 9'd0;
        quotient    = 16'd0;
        divisor_ext = {1'b0, b_reg}; // zero-extend divisor to 9 bits

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], a_reg[i]}; // shift left remainder + bring down dividend bit
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd    = {8'd0, remainder[7:0]}; // zero-extend remainder to 16 bits
    end

endmodule