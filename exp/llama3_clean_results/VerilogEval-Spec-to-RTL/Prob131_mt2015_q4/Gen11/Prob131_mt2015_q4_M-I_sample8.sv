module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    // Simplify the logic by using the properties of XOR and the given functions
    // The expression (a1 | b1) ^ (a2 & b2) can be simplified by recognizing that 
    // a1 and a2 produce the same output for the same inputs, as do b1 and b2.
    // Hence, we can simplify the expression as follows:
    assign z = (a1 | b1) ^ (a1 & b1);
endmodule