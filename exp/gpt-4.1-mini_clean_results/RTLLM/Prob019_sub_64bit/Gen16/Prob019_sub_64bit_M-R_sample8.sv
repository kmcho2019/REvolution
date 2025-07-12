module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_inv = ~B;
    wire [64:0] carry;
    
    assign carry[0] = 1'b1;  // Initial carry-in for two's complement (+1)

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bit_subtract
            // sum bit = A ^ B_inv ^ carry_in
            assign result[i] = A[i] ^ B_inv[i] ^ carry[i];
            // carry out = majority of (A[i], B_inv[i], carry[i])
            assign carry[i+1] = (A[i] & B_inv[i]) | (A[i] & carry[i]) | (B_inv[i] & carry[i]);
        end
    endgenerate

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule