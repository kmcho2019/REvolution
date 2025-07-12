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
    assign z = x == y;
endmodule

// Define the top-level module
module TopLevel(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    // Instantiate Module A and Module B
    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    // Connect the outputs of Module A and Module B to OR and AND gates
    or or1(a1, b1, or_out);
    and and1(a2, b2, and_out);

    // Connect the outputs of the OR and AND gates to an XOR gate
    xor xor1(or_out, and_out, z);
endmodule