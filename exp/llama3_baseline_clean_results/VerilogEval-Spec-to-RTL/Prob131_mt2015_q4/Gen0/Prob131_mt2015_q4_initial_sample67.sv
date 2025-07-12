module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

module topLevelModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, orOut, andOut;

    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    or orGate(b1, a1, orOut);
    and andGate(a2, b2, andOut);
    xor xorGate(orOut, andOut, z);
endmodule