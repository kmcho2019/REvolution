module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // First layer: AND operations
    wire a_and_b, c_and_d;
    assign a_and_b = a & b;
    assign c_and_d = c & d;
    
    // Second layer: OR operation and its complement
    assign out   = a_and_b | c_and_d;
    assign out_n = ~out;
endmodule