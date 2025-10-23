module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x &!y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, sel;

    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    // Use a1 and b1 to control the multiplexers
    assign sel = a1 & b1;

    // Implementing the logic using multiplexers
    wire mux_out1, mux_out2;
    assign mux_out1 = (a1 && b1)? (a1 | b1) : (a1 ^ b1);
    assign mux_out2 = (a2 && b2)? (a2 & b2) : (a2 ^ b2);

    // Final output
    assign z = mux_out1 ^ mux_out2;
endmodule