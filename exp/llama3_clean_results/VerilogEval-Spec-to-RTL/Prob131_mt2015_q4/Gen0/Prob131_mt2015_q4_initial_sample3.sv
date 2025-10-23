module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = !(x && y) && !(~x && ~y);
endmodule

module TopLevel(x, y, z);
    input x, y;
    output z;
    wire w1, w2;
    ModuleA A1(x, y, w1);
    ModuleB B1(x, y, w2);
    wire or_out;
    or or_gate(w1, w2, or_out);
    ModuleA A2(x, y, w1);
    ModuleB B2(x, y, w2);
    wire and_out;
    and and_gate(w1, w2, and_out);
    xor xor_gate(or_out, and_out, z);
endmodule