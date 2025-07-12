// Module A: z = (x ^ y) & x using direct XOR and AND operators
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR(x,y) using basic gates
module B(input x, input y, output z);
    assign z = ~(x ^ y); // XNOR implemented with bitwise operators
endmodule

// Top-level module renamed to "TopModule" to match simulation environment
module TopModule(input x, input y, output z);
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A A1(.x(x), .y(y), .z(a1_out));
    A A2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B B1(.x(x), .y(y), .z(b1_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Use continuous assignments for OR, AND, XOR
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule