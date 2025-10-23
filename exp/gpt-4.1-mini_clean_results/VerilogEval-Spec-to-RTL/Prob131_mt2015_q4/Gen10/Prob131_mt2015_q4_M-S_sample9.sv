module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    // B implements XNOR(x,y)
    assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire a1, a2, b1, b2;
    wire or_out, and_out;

    A a_inst1(.x(x), .y(y), .z(a1));
    A a_inst2(.x(x), .y(y), .z(a2));
    B b_inst1(.x(x), .y(y), .z(b1));
    B b_inst2(.x(x), .y(y), .z(b2));

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule