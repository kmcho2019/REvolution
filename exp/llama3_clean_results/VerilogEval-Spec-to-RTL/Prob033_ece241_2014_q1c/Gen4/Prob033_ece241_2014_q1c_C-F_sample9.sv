module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Directly add a and b and assign the result to s
    assign s = a + b;
    
    // Use dedicated overflow detection logic
    assign overflow = (a[7] == b[7]) && (a[7]!= s[7]);

endmodule