module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, or_ab;

    assign a = x & (x ^ y);  // Directly implement ModuleA functionality
    assign b = (x & y) | (!x & !y);  // Directly implement ModuleB functionality

    assign or_ab = a | b;
    assign z = or_ab ^ (a & b);
endmodule