// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR(x,y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Simplified top-level module reusing outputs of single instances of A and B
module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B
    A A_inst(.x(x), .y(y), .z(a_out));
    B B_inst(.x(x), .y(y), .z(b_out));

    // Use a_out and b_out for both OR and AND inputs
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    assign z = or_out ^ and_out;
endmodule