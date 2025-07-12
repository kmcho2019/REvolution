module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x & y) & ~(~x & ~y);
endmodule

module TopLevel(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out;
    ModuleA A1(x, y, a1_out);
    ModuleB B1(x, y, b1_out);
    ModuleA A2(x, y, a2_out);
    ModuleB B2(x, y, b2_out);
    assign z = (a1_out | b1_out) ^ (a2_out & b2_out);
endmodule