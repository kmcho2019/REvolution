module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    wire a_path, b_path;
    
    // AND gates - sel input is inverted for a_path by using !sel in the expression
    and and_a(a_path, a, ~sel);
    and and_b(b_path, b, sel);
    
    // Final OR gate
    or or_out(out, a_path, b_path);
endmodule