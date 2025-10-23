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
    // Carry occurs if either:
    // 1. Binary sum exceeds 15 (sum_ext[4] = 1), or
    // 2. Sum is between 10-15 (sum_ext[3] & (sum_ext[2] | sum_ext[1]))
    wire overflow = sum_ext[4] | (sum_ext[3] & (sum_ext[2] | sum_ext[1]));

    // Efficient correction application:
    // When overflow=1: sum = sum_ext[3:0] + 6
    // Implemented using optimized bitwise operations:
    assign Sum[3] = sum_ext[3] ^ (overflow & (sum_ext[2] | sum_ext[1]));
    assign Sum[2] = sum_ext[2] ^ (overflow & ~sum_ext[1]);
    assign Sum[1] = sum_ext[1] ^ overflow;
    assign Sum[0] = sum_ext[0];  // LSB doesn't change with +6
    
    assign Cout = overflow;

endmodule