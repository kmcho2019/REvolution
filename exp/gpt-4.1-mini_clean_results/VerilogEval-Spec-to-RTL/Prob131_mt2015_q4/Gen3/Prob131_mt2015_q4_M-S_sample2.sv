// Module A: z = (x ^ y) & x, implemented with continuous assignment
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR(x,y), implemented with continuous assignment
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with two instances each of A and B
module TopModule(input wire x, input wire y, output wire z);
    wire a1, a2, b1, b2;
    wire or_out, and_out;

    A A1(.x(x), .y(y), .z(a1));
    A A2(.x(x), .y(y), .z(a2));

    B B1(.x(x), .y(y), .z(b1));
    B B2(.x(x), .y(y), .z(b2));

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule