module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Split into 16-bit chunks for parallel processing
wire [15:0] A_chunk [3:0];
wire [15:0] B_chunk [3:0];
wire [15:0] res_chunk [3:0];
wire cout [3:0];

assign A_chunk[0] = A[15:0];
assign A_chunk[1] = A[31:16];
assign A_chunk[2] = A[47:32];
assign A_chunk[3] = A[63:48];

assign B_chunk[0] = B[15:0];
assign B_chunk[1] = B[31:16];
assign B_chunk[2] = B[47:32];
assign B_chunk[3] = B[63:48];

// Instantiate 16-bit subtractors with carry chain
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : SUB_CHUNKS
        sub_16bit chunk_sub (
            .A(A_chunk[i]),
            .B(B_chunk[i]),
            .cin(i == 0 ? 1'b1 : cout[i-1]), // Borrow in for subtraction
            .S(res_chunk[i]),
            .cout(cout[i])
        );
    end
endgenerate

// Combine results
assign result = {res_chunk[3], res_chunk[2], res_chunk[1], res_chunk[0]};

// Early overflow detection using only MSB chunk
wire A_sign = A[63];
wire B_sign = B[63];
wire res_sign = result[63];

assign overflow = (~A_sign & B_sign & res_sign) |  // Positive overflow
                  (A_sign & ~B_sign & ~res_sign);  // Negative overflow

endmodule

// 16-bit subtractor module with carry/borrow
module sub_16bit (
    input [15:0] A,
    input [15:0] B,
    input cin,    // Borrow in
    output [15:0] S,
    output cout   // Borrow out
);

assign {cout, S} = A - B - cin;

endmodule