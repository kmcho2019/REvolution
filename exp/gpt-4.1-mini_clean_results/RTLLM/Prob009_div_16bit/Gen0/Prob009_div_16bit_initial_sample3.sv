module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] remainder;
    reg [15:0] quotient;
    reg [7:0]  divisor;
    reg [7:0]  top_bits;
    reg [7:0]  diff;

    remainder = a_reg;
    divisor = b_reg;
    quotient = 0;

    // We perform 16 steps, one for each bit of quotient
    // At each step, extract the top 8 bits of remainder, compare with divisor
    // If >= divisor, subtract divisor and set quotient bit; else quotient bit = 0
    // Then shift left by 1 bit (dropping highest bit and concatenating next dividend bit)
    for(i=15; i>=0; i=i-1) begin
        top_bits = remainder[15:8];
        if(top_bits >= divisor) begin
            diff = top_bits - divisor;
            quotient[i] = 1'b1;
            // Update remainder high bits to diff, shift left 1, bring next bit from remainder low bits
            remainder = {diff, remainder[7:0]};
        end else begin
            quotient[i] = 1'b0;
            // remainder unchanged here, just shift left 1 bit (bring next dividend bit)
            remainder = remainder << 1;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule