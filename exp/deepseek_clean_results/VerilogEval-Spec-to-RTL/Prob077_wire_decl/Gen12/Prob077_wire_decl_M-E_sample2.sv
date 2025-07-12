module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Descriptive wire names showing their function
    wire ab_and = a & b;
    wire cd_and = c & d;
    
    // Output logic
    assign out = ab_and | cd_and;
    assign out_n = ~out;
endmodule