module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire sel_bar;
    wire a_path, b_path;
    
    // Generate complementary select signal
    not(sel_bar, sel);
    
    // Transmission gate style implementation
    and(a_path, a, sel_bar);
    and(b_path, b, sel);
    
    // Combine the paths
    or(out, a_path, b_path);
endmodule