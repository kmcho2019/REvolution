module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    // Directly encode the output 'f' based on the Karnaugh map conditions
    f = (x[3] & ~x[0] & ~x[1] & ~x[2]) |  // Condition for x[3]x[0] = 10 and x[1]x[2] = 00
        (x[3] & ~x[0] & x[1] & ~x[2]) |  // Condition for x[3]x[0] = 10 and x[1]x[2] = 10
        (~x[3] & x[0] & x[1] & x[2]) |  // Condition for x[3]x[0] = 01 and x[1]x[2] = 11
        (x[3] & x[0] & ~x[1] & ~x[2]) |  // Condition for x[3]x[0] = 11 and x[1]x[2] = 00
        (x[3] & x[0] & ~x[1] & x[2]) |  // Condition for x[3]x[0] = 11 and x[1]x[2] = 01
        (x[3] & x[0] & x[1] & ~x[2]);   // Condition for x[3]x[0] = 11 and x[1]x[2] = 10
end

endmodule