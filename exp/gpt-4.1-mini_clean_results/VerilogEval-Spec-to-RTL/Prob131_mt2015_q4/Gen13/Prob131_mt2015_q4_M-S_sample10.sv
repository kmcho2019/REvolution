module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;

    A u_A(.x(x), .y(y), .z(a_out));
    B u_B(.x(x), .y(y), .z(b_out));

    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule