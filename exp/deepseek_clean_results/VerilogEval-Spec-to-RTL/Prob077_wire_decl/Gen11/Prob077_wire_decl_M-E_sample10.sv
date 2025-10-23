module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Create intermediate signals using bitwise operations
    wire ab_and = a & b;
    wire cd_and = c & d;
    
    // Combine using OR operation
    assign out = ab_and | cd_and;
    
    // Generate inverted output
    assign out_n = ~out;
endmodule