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

module top_level(x, y, z);
    input x, y;
    output z;
    wire a_out, b_out;

    ModuleA A1(x, y, a_out);
    ModuleB B1(x, y, b_out);

    assign z = (x == y) ? b_out : a_out;
endmodule