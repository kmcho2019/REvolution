module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Intermediate wires representing the AND gate outputs
    wire ab_and = a & b;
    wire cd_and = c & d;
    
    // Combined OR operation of the AND outputs
    assign out = ab_and | cd_and;
    
    // Inverted output
    assign out_n = ~out;
endmodule