// Combined module for A and B outputs given inputs x and y
module ABPair(input x, input y, output a_out, output b_out);
    wire axorb = x ^ y;
    assign a_out = axorb & x;   // A = (x ^ y) & x
    assign b_out = ~axorb;      // B = ~(x ^ y)
endmodule

// Optimized top-level module using two ABPair instances
module TopModule(input x, input y, output z);
    wire a1, b1, a2, b2;
    wire or_out, and_out;

    ABPair AB1(.x(x), .y(y), .a_out(a1), .b_out(b1));
    ABPair AB2(.x(x), .y(y), .a_out(a2), .b_out(b2));

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule