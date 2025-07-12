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

module TopLevelModule(x, y, z);
    input x, y;
    output z;
    wire w1, w2;
    
    ModuleA A1(x, y, w1);
    ModuleB B1(x, y, w2);
    assign z_or = w1 | w2;
    
    ModuleA A2(x, y, w1);
    ModuleB B2(x, y, w2);
    assign z_and = w1 & w2;
    
    assign z = z_or ^ z_and;
endmodule