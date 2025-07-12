module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    // Implement the logic using MUX-based approach
    wire and_ab = a & b;
    wire and_cd = c & d;
    
    // The MUX acts as an OR gate when select is 1'b1
    assign out = and_ab | and_cd;
    
    // Inverted output
    assign out_n = ~out;

endmodule