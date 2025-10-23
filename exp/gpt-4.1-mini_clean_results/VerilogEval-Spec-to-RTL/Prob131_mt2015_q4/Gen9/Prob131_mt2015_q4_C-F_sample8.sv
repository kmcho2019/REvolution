// Module A: implements z = (x XOR y) AND x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: implements z = XNOR of x and y, i.e. z = ~(x XOR y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// TopModule instantiates two A and two B modules,
// connects first pair outputs to OR gate,
// second pair outputs to AND gate,
// and XORs these two results to produce output z.
module TopModule(input wire x, input wire y, output wire z);
    wire a_out1, b_out1; // outputs from first pair of A and B
    wire a_out2, b_out2; // outputs from second pair of A and B
    wire or_out, and_out;

    // Instantiate first A and B pair
    A a1(.x(x), .y(y), .z(a_out1));
    B b1(.x(x), .y(y), .z(b_out1));

    // Instantiate second A and B pair
    A a2(.x(x), .y(y), .z(a_out2));
    B b2(.x(x), .y(y), .z(b_out2));

    // OR gate on first pair outputs
    assign or_out = a_out1 | b_out1;

    // AND gate on second pair outputs
    assign and_out = a_out2 & b_out2;

    // XOR the results of OR and AND gates to produce final output
    assign z = or_out ^ and_out;
endmodule