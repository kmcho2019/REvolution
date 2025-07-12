// Define Module A
module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Define Module B
module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x | y) | (x & y);
endmodule

// Define the top-level module
module TopLevel(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    // Instantiate Module A and Module B
    ModuleA u_A1(x, y, a1);
    ModuleB u_B1(x, y, b1);
    ModuleA u_A2(x, y, a2);
    ModuleB u_B2(x, y, b2);

    // Connect outputs to OR and AND gates
    or or_gate1(a1, b1, or_out);
    and and_gate1(a2, b2, and_out);

    // Connect OR and AND outputs to XOR gate
    xor xor_gate1(or_out, and_out, z);
endmodule