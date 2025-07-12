module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection:
    // True when sum > 9 (either carry-out or sum[3:0] > 9)
    // Detected as: sum_ext[4] OR (sum_ext[3] AND (sum_ext[2] OR sum_ext[1]))
    wire overflow = sum_ext[4] | (sum_ext[3] & (sum_ext[2] | sum_ext[1]));

    // Apply correction using efficient bitwise operations
    // When overflow=1: sum = sum_ext[3:0] + 6
    // Implemented as:
    // sum[3] = sum_ext[3] ^ (overflow & (sum_ext[2] | sum_ext[1]))
    // sum[2] = sum_ext[2] ^ (overflow & ~sum_ext[1])
    // sum[1] = sum_ext[1] ^ overflow
    // sum[0] = sum_ext[0]
    assign Sum = {sum_ext[3] ^ (overflow & (sum_ext[2] | sum_ext[1])),
                 sum_ext[2] ^ (overflow & ~sum_ext[1]),
                 sum_ext[1] ^ overflow,
                 sum_ext[0]};
    
    // Carry generation
    assign Cout = overflow;

endmodule