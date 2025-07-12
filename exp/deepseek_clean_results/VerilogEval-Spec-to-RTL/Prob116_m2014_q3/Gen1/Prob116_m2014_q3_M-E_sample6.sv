module TopModule(
    input [3:0] x,
    output f
);
    // x[3] is MSB, x[0] is LSB in Verilog vector notation
    // But in the problem statement, inputs are x[3:0] where x[3] is bit 3, x[2] is bit 2, etc.
    // So we'll use x[3], x[2], x[1], x[0] corresponding to x[3:0]

    // Implement the logic derived from Karnaugh map analysis
    assign f = x[3] ? 
               ~(x[2] & ~x[1] & x[0]) :  // When x[3]=1
               ((x[2] & x[1] & x[0]) | (~x[2] & ~x[1] & ~x[0]));  // When x[3]=0
endmodule