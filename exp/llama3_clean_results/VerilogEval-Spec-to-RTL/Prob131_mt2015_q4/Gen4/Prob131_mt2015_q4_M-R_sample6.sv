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

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;
    
    assign a1 = (x ^ y) & x;
    assign a2 = (x ^ y) & x;
    assign b1 = ~(x ^ y);
    assign b2 = ~(x ^ y);
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule