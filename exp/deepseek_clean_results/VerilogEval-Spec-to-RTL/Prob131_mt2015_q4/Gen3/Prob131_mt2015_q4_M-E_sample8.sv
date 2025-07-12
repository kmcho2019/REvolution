module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;  // Same as original
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = x & y;  // Simplified based on waveform analysis
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Directly compute the final logic without intermediate wires
    wire a_out = (x ^ y) & x;
    wire b_out = x & y;
    
    // Combined logic expression
    assign z = (a_out | b_out) ^ (a_out & b_out);
    
    // Alternative implementation using simplified Boolean expression
    // assign z = x & (y | ~(x & y));  // This is equivalent to the above
endmodule