module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    // Based on the simulation waveform, the function for Module B appears to be z = x & y | ~x & ~y
    assign z = (x & y) | (~x & ~y);
endmodule

module TopLevelModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;
    
    ModuleA A1(x, y, a1_out);
    ModuleB B1(x, y, b1_out);
    ModuleA A2(x, y, a2_out);
    ModuleB B2(x, y, b2_out);
    
    or or1(a1_out, b1_out, or_out);
    and and1(a2_out, b2_out, and_out);
    xor xor1(or_out, and_out, z);
endmodule