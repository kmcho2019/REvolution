module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y); // Simplified implementation based on the simulation waveform
endmodule

module OrGate(a, b, z);
    input a, b;
    output z;
    assign z = a | b;
endmodule

module AndGate(a, b, z);
    input a, b;
    output z;
    assign z = a & b;
endmodule

module XorGate(a, b, z);
    input a, b;
    output z;
    assign z = a ^ b;
endmodule

module OutputLogic(a1_out, b1_out, a2_out, b2_out, z);
    input a1_out, b1_out, a2_out, b2_out;
    output z;
    wire or_out, and_out;
    OrGate or_g(a1_out, b1_out, or_out);
    AndGate and_g(a2_out, b2_out, and_out);
    XorGate xor_g(or_out, and_out, z);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out;
    ModuleA A1(x, y, a1_out);
    ModuleB B1(x, y, b1_out);
    ModuleA A2(x, y, a2_out);
    ModuleB B2(x, y, b2_out);
    OutputLogic ol(a1_out, b1_out, a2_out, b2_out, z);
endmodule