// Define the A submodule
module A(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

// Define the B submodule
module B(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);
endmodule

// Define the top-level module
module top(
    input x,
    input y,
    output z
);
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;
    
    // Instantiate A and B submodules
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));
    
    // Connect outputs to OR and AND gates
    or or1(.a(a1_out), .b(b1_out), .y(or_out));
    and and1(.a(a2_out), .b(b2_out), .y(and_out));
    
    // Connect OR and AND outputs to XOR gate
    xor xor1(.a(or_out), .b(and_out), .y(z));
endmodule

// Define the OR gate
module or(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// Define the AND gate
module and(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

// Define the XOR gate
module xor(
    input a,
    input b,
    output y
);
    assign y = a ^ b;
endmodule