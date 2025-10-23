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
    wire a1, b1, a2, b2, mux1_out, mux2_out;
    
    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);
    
    mux2 mux1(a1, b1, a2, mux1_out);
    mux2 mux2(a2, b2, b1, mux2_out);
    xor xor1(mux1_out, mux2_out, z);
endmodule

module mux2(a, b, sel, out);
    input a, b, sel;
    output out;
    assign out = sel ? b : a;
endmodule