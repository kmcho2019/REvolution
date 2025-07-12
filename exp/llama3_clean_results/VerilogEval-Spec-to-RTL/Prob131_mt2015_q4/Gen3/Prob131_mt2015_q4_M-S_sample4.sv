module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x &!y);
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire a_out1, b_out1, a_out2, b_out2;

    ModuleA A1(x, y, a_out1);
    ModuleB B1(x, y, b_out1);

    ModuleA A2(x, y, a_out2);
    ModuleB B2(x, y, b_out2);

    wire or_out, and_out;

    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;

    assign z = or_out ^ and_out;
endmodule