module ModuleC(x, y, z);
    input x, y;
    output z;
    assign z = ((x ^ y) & x) | ((x & y) | (!x &!y));
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    ModuleC C(x, y, z);
endmodule