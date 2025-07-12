module TopModule (
    input a,
    input b,
    output out
);
    // Transmission gate implementation of XNOR
    wire ab, a_n, b_n;
    wire out_p, out_n;
    
    // Generate complements
    not (a_n, a);
    not (b_n, b);
    
    // Transmission gate logic
    tranif1 (ab, a, b);      // Pass a when b is high
    tranif0 (ab, a_n, b_n);  // Pass a_n when b is low
    
    // Output stage with weak keeper
    assign out = ab;
    
    // Small keeper circuit to prevent floating output
    pmos (out_p, 1'b1, ab);
    nmos (out_n, 1'b0, ab);
endmodule