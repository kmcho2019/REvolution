module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (~y);
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, sel;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    assign sel = x & y; // Select line for the multiplexer
    assign z = sel ? b : a; // Use ModuleB's output when sel is true, otherwise use ModuleA's output
endmodule