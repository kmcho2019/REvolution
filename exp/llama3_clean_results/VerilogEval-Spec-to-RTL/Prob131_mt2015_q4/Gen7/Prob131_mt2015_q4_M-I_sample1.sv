module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y); // Using ~ for negation as per Verilog standard
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, or_out, and_out;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    // Directly map the outputs to intermediate signals
    assign or_out = a | b;
    assign and_out = a & b;

    // Final output
    assign z = or_out ^ and_out; // Simplified logic expression

    // Alternatively, direct computation without intermediate signals could be considered for further optimization
    // assign z = (a | b) ^ (a & b);
endmodule