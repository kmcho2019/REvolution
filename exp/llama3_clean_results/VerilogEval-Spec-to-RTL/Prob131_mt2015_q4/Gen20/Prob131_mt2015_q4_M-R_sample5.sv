module refactored_module(x, y, z);
    input x, y;
    output z;
    wire a_out, b_out;

    // Simplified logic for ModuleA using XOR
    assign a_out = x & (~y);

    // Simplified logic for ModuleB using XNOR
    assign b_out = ~(x ^ y);

    // Directly calculate the final output 'z'
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule