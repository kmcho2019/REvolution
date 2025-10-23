module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    /* Direct optimal implementation with synthesis hints */
    assign sum = a ^ b ^ cin;  // Parity function
    assign cout = (a & b) | (a & cin) | (b & cin);  // Majority function
    
    // Synthesis attributes for optimization
    (* use_dsp48 = "no" *)  // Ensure this doesn't get implemented in DSP blocks
    (* optimize_power = "true" *)
    (* keep_hierarchy = "yes" *)  // Preserve hierarchy for better local optimization
endmodule