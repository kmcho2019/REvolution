module TopModule(
    input x,
    input y,
    output reg z
);

always @(*) begin
    // Directly implementing the boolean function
    z = (x ^ y) & x;
end

endmodule