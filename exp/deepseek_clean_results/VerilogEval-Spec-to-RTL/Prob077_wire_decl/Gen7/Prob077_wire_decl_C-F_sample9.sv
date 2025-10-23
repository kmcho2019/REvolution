module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // First layer: AND operations with descriptive wire names
    wire ab_and = a & b;
    wire cd_and = c & d;
    
    // Second layer: OR operation and inversion
    assign out = ab_and | cd_and;
    assign out_n = ~out;
endmodule