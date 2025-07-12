module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Count the number of 1s in the inputs
    wire [2:0] count = a + b + c + d;
    
    // q is 1 when count is even (including all zeros)
    assign q = (count == 0) || (count[0] == 0);
endmodule