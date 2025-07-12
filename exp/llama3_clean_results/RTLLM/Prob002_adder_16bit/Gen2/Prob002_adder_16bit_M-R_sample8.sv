// Define the 1-bit full adder module
module full_adder(
    input  a,
    input  b,
    input  Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input        Cin,
    output [15:0] y,
    output       Co
);
    
    // Instantiate 16 full adder modules in a ripple-carry fashion
    full_adder fa0(a[0], b[0], Cin, y[0], y[1]);
    full_adder fa1(a[1], b[1], y[1], y[2], y[3]);
    full_adder fa2(a[2], b[2], y[3], y[4], y[5]);
    full_adder fa3(a[3], b[3], y[5], y[6], y[7]);
    full_adder fa4(a[4], b[4], y[7], y[8], y[9]);
    full_adder fa5(a[5], b[5], y[9], y[10], y[11]);
    full_adder fa6(a[6], b[6], y[11], y[12], y[13]);
    full_adder fa7(a[7], b[7], y[13], y[14], y[15]);
    full_adder fa8(a[8], b[8], y[1], y[9], y[10]);
    full_adder fa9(a[9], b[9], y[3], y[11], y[12]);
    full_adder fa10(a[10], b[10], y[5], y[13], y[14]);
    full_adder fa11(a[11], b[11], y[7], y[15], Co);
    full_adder fa12(a[12], b[12], y[9], y[0], y[2]);
    full_adder fa13(a[13], b[13], y[11], y[4], y[6]);
    full_adder fa14(a[14], b[14], y[13], y[8], y[10]);
    full_adder fa15(a[15], b[15], y[15], Co, y[12]);
    
endmodule