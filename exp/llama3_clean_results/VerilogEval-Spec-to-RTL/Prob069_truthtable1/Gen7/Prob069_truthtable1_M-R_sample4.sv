module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

// Using an always block to implement the combinational logic
always @(*) begin
    f = (x2 & ~x3) | (x1 & x3);
end

endmodule