// Define the TopModule that integrates the adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Calculate the sum of a and b
    assign s = a + b;

    // Detect signed overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule