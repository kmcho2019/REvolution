// 4-bit Segment Adder with bitwise operations
module segment_adder(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout
);
    wire [4:1] sum_bits, carry_bits;

    // Bitwise XOR for sum bits
    for (genvar i = 1; i <= 4; i++) begin
        assign sum_bits[i] = A[i] ^ B[i];
    end

    // Bitwise AND for carry bits
    for (genvar i = 1; i <= 4; i++) begin
        assign carry_bits[i] = A[i] & B[i];
    end

    // Calculate final sum bits
    for (genvar i = 1; i <= 4; i++) begin
        assign S[i] = sum_bits[i] ^ Cin;
    end

    // Calculate carry-out
    assign Cout = (carry_bits[4] & Cin) | (carry_bits[3] & carry_bits[4]) | (carry_bits[2] & carry_bits[3] & carry_bits[4]) | (carry_bits[1] & carry_bits[2] & carry_bits[3] & carry_bits[4]);
endmodule

// 32-bit Segmented Bitwise Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [8:1] segment_cout;

    // Segment adders
    for (genvar i = 1; i <= 8; i++) begin
        segment_adder segment_adder_i(
            .A(A[(i*4):((i-1)*4+1)],
            .B(B[(i*4):((i-1)*4+1)],
            .Cin(i == 1 ? 1'b0 : segment_cout[i-1]),
            .S(S[(i*4):((i-1)*4+1)],
            .Cout(segment_cout[i])
        );
    end

    // Final carry-out
    assign C32 = segment_cout[8];
endmodule