module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_bar;
    wire out_wire;
    
    // Generate complementary select signal
    not (sel_bar, sel);
    
    // Transmission gate implementation
    tranif0 (out_wire, a, sel_bar);
    tranif1 (out_wire, b, sel);
    
    // Buffer the output (required for proper drive strength)
    buf (out, out_wire);
endmodule