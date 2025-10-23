module ModuleA(x, y, z);
    input x, y;
    output z;
    // Using De Morgan's law to potentially reduce area
    assign z = ~(~x | y); // Equivalent to x & ~y
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    // Implementing equality check directly
    assign z = (x & y) | (~x & ~y); // Equivalent to ~(x ^ y)
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    // The XOR operation remains the same as it directly implements the required functionality
    assign z = a ^ b;
endmodule