module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

always @(*) begin
    // Compute the output based on the conditions
    f = (x2 & ~x3) | (x1 & x3);
end

endmodule