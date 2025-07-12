module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Module B can be represented by the K-map or truth table given.
// From the given simulation waveform, we can infer the logic of Module B as z = ~(x ^ y).
module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

module TopLevelModule(x, y, z);
    input x, y;
    output z;
    wire A1_out, B1_out, A2_out, B2_out, OR_out, AND_out;
    
    ModuleA A1(x, y, A1_out);
    ModuleB B1(x, y, B1_out);
    ModuleA A2(x, y, A2_out);
    ModuleB B2(x, y, B2_out);
    
    // Connecting the first pair of A and B to an OR gate
    or or1(A1_out, B1_out, OR_out);
    // Connecting the second pair of A and B to an AND gate
    and and1(A2_out, B2_out, AND_out);
    // Connecting the outputs of the OR and AND gates to an XOR gate
    xor xor1(OR_out, AND_out, z);
endmodule

module or(a, b, out);
    input a, b;
    output out;
    assign out = a | b;
endmodule

module and(a, b, out);
    input a, b;
    output out;
    assign out = a & b;
endmodule

module xor(a, b, out);
    input a, b;
    output out;
    assign out = a ^ b;
endmodule