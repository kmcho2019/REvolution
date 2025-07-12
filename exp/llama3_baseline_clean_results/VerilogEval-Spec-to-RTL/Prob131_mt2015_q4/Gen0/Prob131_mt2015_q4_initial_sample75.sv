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

module top_level(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;
    
    ModuleA u1(x, y, a1);
    ModuleB u2(x, y, b1);
    ModuleA u3(x, y, a2);
    ModuleB u4(x, y, b2);
    
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule