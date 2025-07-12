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
    wire a1, b1, a2, b2, or_out, and_out;

    assign a1 = (x ^ y) & x;
    assign b1 = (x & y) | (!x & !y);
    assign a2 = (x ^ y) & x;
    assign b2 = (x & y) | (!x & !y);

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule

// Refactored version
module RefactoredTopModule(x, y, z);
    input x, y;
    output z;
    wire or_out, and_out;

    assign or_out = ((x ^ y) & x) | ((x & y) | (!x & !y));
    assign and_out = ((x ^ y) & x) & ((x & y) | (!x & !y));
    assign z = or_out ^ and_out;
endmodule