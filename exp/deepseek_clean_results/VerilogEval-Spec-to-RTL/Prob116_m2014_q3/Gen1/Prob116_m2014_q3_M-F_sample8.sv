module TopModule(
    input [3:0] x,
    output f
);
    // Correct implementation based on K-map analysis
    // x[3] is MSB, x[0] is LSB in Verilog
    assign f = (x[3] & ~x[1]) |          // Covers bottom-left and bottom-middle 1s
               (~x[3] & x[2] & x[1]) |   // Covers the single 1 in 01-11
               (x[3] & ~x[0]);           // Covers the two 1s in top-left and middle-left
endmodule