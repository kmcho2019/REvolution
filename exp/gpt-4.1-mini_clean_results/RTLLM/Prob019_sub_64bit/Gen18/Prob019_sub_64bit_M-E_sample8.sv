module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Internal wires for borrow chain
    wire [63:0] borrow;

    // Bit 0 subtraction with initial borrow_in = 0
    // difference = A_bit - B_bit - borrow_in
    // borrow_out = 1 if (A_bit < B_bit + borrow_in)
    assign {borrow[0], result[0]} = {1'b0, A[0]} - {1'b0, B[0]} - 1'b0;

    genvar i;
    generate
        for(i=1; i<64; i=i+1) begin : bit_sub
            // Perform subtraction per bit with borrow chain:
            // borrow[i] = 1 if A[i] < B[i] + borrow[i-1]
            // Using full 2-bit subtraction: A_bit - B_bit - borrow_in
            wire borrow_in = borrow[i-1];
            wire [1:0] sub_val;
            // sub_val = A_bit - B_bit - borrow_in
            assign sub_val = {1'b0, A[i]} - {1'b0, B[i]} - borrow_in;
            assign result[i] = sub_val[0];
            assign borrow[i] = ~sub_val[1]; 
            // Explanation:
            // sub_val[1] is MSB of subtraction result (borrow-out bit),
            // If sub_val[1] == 0, borrow out = 1
            // If sub_val[1] == 1, borrow out = 0
        end
    endgenerate

    // Overflow detection for signed 64-bit subtraction
    // Overflow occurs if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule