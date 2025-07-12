// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR(x,y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with simplified instantiation and reuse of outputs
module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B modules
    A A1(.x(x), .y(y), .z(a_out));
    B B1(.x(x), .y(y), .z(b_out));

    // Reuse outputs for OR and AND
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;

    // XOR of OR and AND outputs produces final output
    assign z = or_out ^ and_out;
endmodule