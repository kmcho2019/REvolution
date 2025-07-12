module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (!y); // Optimized logic from Example 2
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x == y); // Already optimized
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    assign z = a | b; // Simplified logic from Example 1
endmodule