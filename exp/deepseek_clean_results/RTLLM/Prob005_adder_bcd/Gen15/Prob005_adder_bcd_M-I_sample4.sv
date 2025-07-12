module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out
    wire [4:0] sum_ext = A + B + Cin;
    
    // Shared sub-expression
    wire sum_ge_10 = sum_ext[3] & (sum_ext[2] | sum_ext[1]);
    
    // Optimized overflow detection
    wire overflow = sum_ext[4] | sum_ge_10;

    // Efficient +6 correction through selective bit toggling:
    // +6 = 0110 binary, which toggles bits 3, 2, and 1
    // Bit 3: toggle when overflow occurs
    // Bit 2: toggle when overflow occurs and sum_ext[1] is 0
    // Bit 1: always toggle when overflow occurs
    // Bit 0: never changes
    assign Sum = {sum_ext[3] ^ overflow,
                 sum_ext[2] ^ (overflow & ~sum_ext[1]),
                 sum_ext[1] ^ overflow,
                 sum_ext[0]};
    
    assign Cout = overflow;

endmodule