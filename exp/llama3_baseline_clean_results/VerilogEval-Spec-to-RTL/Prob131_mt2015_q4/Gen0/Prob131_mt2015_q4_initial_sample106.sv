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

module topLevel(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, orOut, andOut;
    
    ModuleA u1(x, y, a1);
    ModuleB u2(x, y, b1);
    ModuleA u3(x, y, a2);
    ModuleB u4(x, y, b2);
    
    or orGate(b1, a1, orOut);
    and andGate(a2, b2, andOut);
    xor xorGate(orOut, andOut, z);
endmodule