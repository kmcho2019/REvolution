module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    // Corrected logic based on the Karnaugh map
    f = (x[3] & (x[1] | x[2])) |  // x[3] is 1 and at least one of x[1] or x[2] is 1
        (~x[3] & x[0] & x[1] & x[2]);  // x[3] is 0, x[0] is 1, and both x[1] and x[2] are 1
end

endmodule