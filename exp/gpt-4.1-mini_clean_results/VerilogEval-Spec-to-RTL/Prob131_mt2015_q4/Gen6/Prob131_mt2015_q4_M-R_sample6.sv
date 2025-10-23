// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR(x,y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with two instances each of A and B and specified gate connections
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate first A and B modules
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));

    // Instantiate second A and B modules
    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Connect first pair outputs to OR gate
    assign or_out = a1_out | b1_out;

    // Connect second pair outputs to AND gate
    assign and_out = a2_out & b2_out;

    // Final output is XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule