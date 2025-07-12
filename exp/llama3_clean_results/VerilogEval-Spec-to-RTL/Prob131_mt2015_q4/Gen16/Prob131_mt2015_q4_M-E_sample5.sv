module ModuleC(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x &!y) | (x & (x ^ y));
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire c;

    ModuleC C(x, y, c);
    assign z = c ^ (c & (x & y));
endmodule