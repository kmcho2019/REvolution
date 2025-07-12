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

module TopLevel(x, y, z);
    input x, y;
    output z;
    wire outA1, outB1, outA2, outB2, orOut, andOut;

    ModuleA A1(x, y, outA1);
    ModuleB B1(x, y, outB1);
    ModuleA A2(x, y, outA2);
    ModuleB B2(x, y, outB2);

    or or1(outA1, outB1, orOut);
    and and1(outA2, outB2, andOut);

    xor xor1(orOut, andOut, z);
endmodule