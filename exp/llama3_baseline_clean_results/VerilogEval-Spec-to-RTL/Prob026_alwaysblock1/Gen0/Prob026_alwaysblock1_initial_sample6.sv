module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b; // Continuous assignment for AND operation

always @(*) begin // Combinational always block
    out_alwaysblock = a & b; // Procedural assignment for AND operation
end

endmodule