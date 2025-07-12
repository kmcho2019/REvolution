module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    // Simplified logic based on observed patterns in the Karnaugh map
    f = (x[3] & ~(~x[1] & ~x[2])) |  // x[3] is 1 and x[1]x[2] is not 00
        (~x[3] & x[0] & x[1] & x[2]);  // x[3] is 0, x[0] is 1, and x[1]x[2] is 11
end

endmodule