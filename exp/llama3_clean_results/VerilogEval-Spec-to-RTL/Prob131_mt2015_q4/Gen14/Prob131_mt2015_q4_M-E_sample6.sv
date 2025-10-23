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
    wire a_out, b_out, mux_out1, mux_out2;

    ModuleA a1(x, y, a_out);
    ModuleB b1(x, y, b_out);

    // Using 2-to-1 multiplexers to select between ModuleA and ModuleB outputs
    assign mux_out1 = (x == 1'b0) ? b_out : a_out;
    assign mux_out2 = (y == 1'b0) ? a_out : b_out;

    // Applying logical operations to produce the final output z
    assign z = (mux_out1 | mux_out2) ^ (mux_out1 & mux_out2);
endmodule

// Alternative implementation using a single multiplexer
module AltTopModule(x, y, z);
    input x, y;
    output z;
    wire a_out, b_out, mux_out;

    ModuleA a1(x, y, a_out);
    ModuleB b1(x, y, b_out);

    // Using a 2-to-1 multiplexer to select between ModuleA and ModuleB outputs
    assign mux_out = (x & y) ? a_out : b_out;

    // Applying logical operations to produce the final output z
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule