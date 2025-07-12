// Define Module A
module ModuleA(x, y, z);
    input x;
    input y;
    output z;

    assign z = (x ^ y) & x;
endmodule

// Define Module B based on the observed behavior
module ModuleB(x, y, z);
    input x;
    input y;
    output z;

    assign z = (x & y) | (~x & ~y);
endmodule

// Define the top-level module
module TopLevel(x, y, z);
    input x;
    input y;
    output z;

    // Instantiate Module A and Module B
    wire a1_out, a2_out, b1_out, b2_out;
    wire or_out, and_out;

    ModuleA a1(x, y, a1_out);
    ModuleB b1(x, y, b1_out);

    ModuleA a2(x, y, a2_out);
    ModuleB b2(x, y, b2_out);

    // Connect outputs to OR and AND gates
    or or_gate(a1_out, b1_out, or_out);
    and and_gate(a2_out, b2_out, and_out);

    // Connect OR and AND outputs to XOR gate
    xor xor_gate(or_out, and_out, z);
endmodule