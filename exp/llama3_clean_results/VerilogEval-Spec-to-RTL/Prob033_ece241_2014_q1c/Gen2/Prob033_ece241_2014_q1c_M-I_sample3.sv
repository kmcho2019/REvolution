module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Directly add a and b and assign the result to s
    assign s = a + b;
    
    // Detect overflow by checking the carry-out of the addition
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

    // Alternative overflow detection using a dedicated logic
    // wire [8:0] sum;
    // assign sum = {1'b0, a} + {1'b0, b};
    // assign overflow = sum[8];

endmodule