module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire a, b;
    wire or_out, and_out;

    A a_inst(.x(x), .y(y), .z(a));
    B b_inst(.x(x), .y(y), .z(b));

    assign or_out = a | b;
    assign and_out = a & b;
    assign z = or_out ^ and_out;
endmodule