module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire         overflow
);

    wire [63:0] diff;
    wire [63:0] borrow;
    wire        ovf;

    assign diff = A - B;
    assign borrow = (A < B) ? 64'd1 : 64'd0;
    assign ovf = (A[63] == B[63] && A[63] != diff[63]) ? 1'b1 : 1'b0;

    assign result = diff;
    assign overflow = ovf;

endmodule