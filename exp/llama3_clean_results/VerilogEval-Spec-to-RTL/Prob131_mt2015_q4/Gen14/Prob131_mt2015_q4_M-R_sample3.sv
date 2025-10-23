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

module TopModule(x, y, z);
    input x, y;
    output z;
    wire z_A1, z_B1, z_A2, z_B2;
    
    ModuleA A1(x, y, z_A1);
    ModuleB B1(x, y, z_B1);
    ModuleA A2(x, y, z_A2);
    ModuleB B2(x, y, z_B2);
    
    wire or_out, and_out;
    assign or_out = z_A1 | z_B1;
    assign and_out = z_A2 & z_B2;
    
    assign z = or_out ^ and_out;
endmodule