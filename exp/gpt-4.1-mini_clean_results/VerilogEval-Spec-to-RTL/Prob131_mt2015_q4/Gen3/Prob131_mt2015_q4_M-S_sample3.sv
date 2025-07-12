// Module A: z = (x ^ y) & x, combinational continuous assignment
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = XNOR(x, y), combinational continuous assignment
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with two A and two B submodules, simplified by instantiating each only once and reusing outputs
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Instantiate one A and one B module
    A A_inst(.x(x), .y(y), .z(a_out));
    B B_inst(.x(x), .y(y), .z(b_out));

    // OR gate of outputs from A and B
    or or_gate(or_out, a_out, b_out);

    // AND gate of the same outputs (reused)
    and and_gate(and_out, a_out, b_out);

    // XOR gate for final output
    xor xor_gate(z, or_out, and_out);
endmodule