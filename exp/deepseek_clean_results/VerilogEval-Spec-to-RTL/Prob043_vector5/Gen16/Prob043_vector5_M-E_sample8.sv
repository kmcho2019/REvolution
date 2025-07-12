module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    wire [4:0] cmp_a, cmp_b, cmp_c, cmp_d, cmp_e;
    
    // Generate comparison vectors for each input
    assign cmp_a = {a~^a, a~^b, a~^c, a~^d, a~^e};
    assign cmp_b = {b~^a, b~^b, b~^c, b~^d, b~^e};
    assign cmp_c = {c~^a, c~^b, c~^c, c~^d, c~^e};
    assign cmp_d = {d~^a, d~^b, d~^c, d~^d, d~^e};
    assign cmp_e = {e~^a, e~^b, e~^c, e~^d, e~^e};
    
    // Concatenate all comparison vectors
    assign out = {cmp_a, cmp_b, cmp_c, cmp_d, cmp_e};

endmodule