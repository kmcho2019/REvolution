module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Combined logic using ternary operators
    assign out = (a & b) ? 1'b1 : (c & d) ? 1'b1 : 1'b0;
    
    // Inverted output
    assign out_n = ~out;
endmodule