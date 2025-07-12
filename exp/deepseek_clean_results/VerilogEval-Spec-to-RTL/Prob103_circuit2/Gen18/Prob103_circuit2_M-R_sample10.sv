module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Count number of 1s in inputs (0-4 possible)
    wire [1:0] count = a + b + c + d;
    
    // Output is 1 when count is 0, 2, or 4 (even parity)
    assign q = (count == 2'b00) | (count == 2'b10);

endmodule