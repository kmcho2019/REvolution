module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b; // Continuous assignment for AND operation

always @(*) begin
    out_alwaysblock = a & b; // Combinational always block for AND operation
end

endmodule