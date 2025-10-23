module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // First layer: AND operations with descriptive wire names
    wire a_and_b = a & b;
    wire c_and_d = c & d;
    
    // Second layer: OR operation and inversion
    assign out = a_and_b | c_and_d;
    assign out_n = ~out;
endmodule