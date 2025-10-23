module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Combined AND-OR logic using ternary operators
    assign out = (a & b) | (c & d);
    
    // Inverted output remains simple
    assign out_n = ~out;
endmodule