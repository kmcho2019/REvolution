module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Input vector for cleaner representation
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Generate all 25 pairwise comparisons
    // Organized as 5 groups of 5 comparisons each
    wire [4:0] cmp_a, cmp_b, cmp_c, cmp_d, cmp_e;
    
    assign cmp_a = {~(inputs[4] ^ inputs[4]), ~(inputs[4] ^ inputs[3]), 
                   ~(inputs[4] ^ inputs[2]), ~(inputs[4] ^ inputs[1]), 
                   ~(inputs[4] ^ inputs[0])};
                   
    assign cmp_b = {~(inputs[3] ^ inputs[4]), ~(inputs[3] ^ inputs[3]), 
                   ~(inputs[3] ^ inputs[2]), ~(inputs[3] ^ inputs[1]), 
                   ~(inputs[3] ^ inputs[0])};
                   
    assign cmp_c = {~(inputs[2] ^ inputs[4]), ~(inputs[2] ^ inputs[3]), 
                   ~(inputs[2] ^ inputs[2]), ~(inputs[2] ^ inputs[1]), 
                   ~(inputs[2] ^ inputs[0])};
                   
    assign cmp_d = {~(inputs[1] ^ inputs[4]), ~(inputs[1] ^ inputs[3]), 
                   ~(inputs[1] ^ inputs[2]), ~(inputs[1] ^ inputs[1]), 
                   ~(inputs[1] ^ inputs[0])};
                   
    assign cmp_e = {~(inputs[0] ^ inputs[4]), ~(inputs[0] ^ inputs[3]), 
                   ~(inputs[0] ^ inputs[2]), ~(inputs[0] ^ inputs[1]), 
                   ~(inputs[0] ^ inputs[0])};

    // Concatenate all comparisons in specified order
    assign out = {cmp_a, cmp_b, cmp_c, cmp_d, cmp_e};

endmodule