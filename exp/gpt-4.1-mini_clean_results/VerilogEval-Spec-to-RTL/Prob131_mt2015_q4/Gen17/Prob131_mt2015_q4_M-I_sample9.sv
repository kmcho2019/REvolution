// Module A: computes z = (x ^ y) & x, but now receives xor_xy as input instead of x,y
module A(input wire x, input wire xor_xy, output wire a_out);
    assign a_out = xor_xy & x;
endmodule

// Module B: computes z = ~(x ^ y), now receives xor_xy as input
module B(input wire xor_xy, output wire b_out);
    assign b_out = ~xor_xy;
endmodule

// Top module: compute common xor_xy once, feed to two A and two B modules
// Connect outputs as before: (A1|B1) XOR (A2&B2)
module TopModule(input wire x, input wire y, output wire z);
    wire xor_xy;
    wire a1, b1, a2, b2;
    wire or_out, and_out;

    assign xor_xy = x ^ y;

    // First pair of modules
    A A1(.x(x), .xor_xy(xor_xy), .a_out(a1));
    B B1(.xor_xy(xor_xy), .b_out(b1));
    assign or_out = a1 | b1;

    // Second pair of modules
    A A2(.x(x), .xor_xy(xor_xy), .a_out(a2));
    B B2(.xor_xy(xor_xy), .b_out(b2));
    assign and_out = a2 & b2;

    assign z = or_out ^ and_out;
endmodule