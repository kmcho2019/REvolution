module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire         overflow
);

    wire [63:0] diff;
    wire [63:0] borrow;
    wire        ovf;

    // Perform subtraction bit by bit using XOR and AND gates
    assign diff[0] = A[0] ^ B[0];
    assign borrow[0] = A[0] & B[0];

    // Propagate borrow signal to next bit position
    assign borrow[1] = borrow[0] | (A[1] & B[1]);
    assign diff[1] = A[1] ^ B[1] ^ borrow[0];

    // Repeat for all 64 bits
    genvar i;
    generate
        for (i = 2; i < 64; i++) begin
            assign borrow[i] = borrow[i-1] | (A[i] & B[i]);
            assign diff[i] = A[i] ^ B[i] ^ borrow[i-1];
        end
    endgenerate

    // Detect overflow by comparing sign bits
    assign ovf = (A[63]!= B[63]) && (A[63] == diff[63]);

    // Assign result and overflow outputs
    assign result = diff;
    assign overflow = ovf;

endmodule