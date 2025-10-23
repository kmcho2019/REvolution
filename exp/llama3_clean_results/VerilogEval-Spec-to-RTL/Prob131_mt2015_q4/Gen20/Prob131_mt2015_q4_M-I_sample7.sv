module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (x ^ y); // Maintaining the direct implementation
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = !(x ^ y); // Simplified implementation based on the simulation waveform
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    // Optimized expression for z, considering the properties of XOR, OR, and AND
    assign z = (a | !b) ^ (a & !b);
endmodule