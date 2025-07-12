module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire not_sel;
    wire a_path, b_path;
    
    // Invert the select signal
    not inv_sel(not_sel, sel);
    
    // AND gates for both paths
    and and_a(a_path, a, not_sel);
    and and_b(b_path, b, sel);
    
    // Final OR gate
    or or_out(out, a_path, b_path);
endmodule