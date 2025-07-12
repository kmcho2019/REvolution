module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out (5-bit)
    wire [4:0] sum_ext = A + B + Cin;
    
    // Optimized overflow detection:
    // sum > 9 when either:
    // 1. Carry-out occurs (sum_ext[4] = 1), or
    // 2. Any of these bit patterns occur:
    //    - 101x (10 or 11)
    //    - 1001 (9)
    //    - 11xx (12-15)
    wire overflow = sum_ext[4] | 
                   (sum_ext[3] & sum_ext[1]) | 
                   (sum_ext[3] & sum_ext[2]);

    // Apply correction using efficient bitwise operations
    // When overflow=1: sum = sum[3:0] + 6
    // Implemented as:
    // sum[3] = sum_ext[3] ^ (overflow & (sum_ext[2] | sum_ext[1]))
    // sum[2] = sum_ext[2] ^ (overflow & ~sum_ext[1])
    // sum[1] = sum_ext[1] ^ overflow
    // sum[0] = sum_ext[0]
    assign Sum = {sum_ext[3] ^ (overflow & (sum_ext[2] | sum_ext[1])),
                 sum_ext[2] ^ (overflow & ~sum_ext[1]),
                 sum_ext[1] ^ overflow,
                 sum_ext[0]};
    
    assign Cout = overflow;

endmodule