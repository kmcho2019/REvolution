module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y);
endmodule

module topLevel(x, y, z);
    input x, y;
    output z;
    wire w1, w2;
    
    ModuleA A1(x, y, w1);
    ModuleB B1(x, y, w2);
    or or1(w1, w2, w1);
    
    ModuleA A2(x, y, w2);
    ModuleB B2(x, y, w2);
    and and1(w1, w2, w2);
    
    xor xor1(w1, w2, z);
endmodule