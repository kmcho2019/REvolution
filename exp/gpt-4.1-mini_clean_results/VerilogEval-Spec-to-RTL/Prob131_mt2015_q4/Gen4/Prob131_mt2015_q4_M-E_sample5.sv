// Module A: implements z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: implements z = XNOR(x,y) = ~(x ^ y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with one A and one B instance,
// reusing their outputs for the required logic
module TopModule(input x, input y, output z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Instantiate A and B once each
    A a_inst (.x(x), .y(y), .z(a_out));
    B b_inst (.x(x), .y(y), .z(b_out));

    // First pair: OR gate of A and B outputs
    assign or_out = a_out | b_out;
    // Second pair: AND gate of A and B outputs
    assign and_out = a_out & b_out;

    // Final output is XOR of the two results
    assign z = or_out ^ and_out;
endmodule