module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (x ^ y); // Direct implementation from the problem statement
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y); // Direct implementation based on the simulation waveform
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    // Simplifying the expression for z based on the properties of XOR, OR, and AND
    assign z = (a | b) ^ (a & b);
endmodule