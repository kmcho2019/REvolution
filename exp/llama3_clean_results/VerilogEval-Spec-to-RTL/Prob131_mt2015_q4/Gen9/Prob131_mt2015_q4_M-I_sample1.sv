module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x & ~y); // Existing simplified logic: x and not y
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y); // Optimized logic: not (x XOR y), which is equivalent to x and y or not x and not y
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;

    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    assign or_out = a1 | b1; // OR gate
    assign and_out = a2 & b2; // AND gate
    assign z = or_out ^ and_out; // Final XOR operation
endmodule