module TopModule(
    input a,
    input b,
    output out
);
    wire ab, nab, n_a, n_b;
    
    // Generate complements
    not(n_a, a);
    not(n_b, b);
    
    // Transmission gate logic
    tranif1(ab, a, b);      // Conducts when b=1
    tranif0(nab, n_a, n_b); // Conducts when b=0
    
    // Combine outputs
    bufif1(out, ab, 1'b1);
    bufif0(out, nab, 1'b1);
endmodule