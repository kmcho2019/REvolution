module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Parameter for potential width extension
    parameter WIDTH = 1;
    
    // First layer AND operations combined
    wire [1:0] and_results = {a & b, c & d};
    
    // Second layer OR operation using reduction
    assign out = |and_results;
    
    // Inverted output
    assign out_n = ~out;
endmodule