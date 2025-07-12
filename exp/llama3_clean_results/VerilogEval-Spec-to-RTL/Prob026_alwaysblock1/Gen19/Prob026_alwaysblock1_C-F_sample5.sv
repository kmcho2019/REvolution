module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

// Using assign statement for efficiency and ease of optimization
assign out_assign = a & b;

// Use an always @(*) block for combinational logic to ensure correct handling
always @(*) begin
    // Directly assign the result of the AND operation to out_alwaysblock
    out_alwaysblock = a & b;
end

endmodule