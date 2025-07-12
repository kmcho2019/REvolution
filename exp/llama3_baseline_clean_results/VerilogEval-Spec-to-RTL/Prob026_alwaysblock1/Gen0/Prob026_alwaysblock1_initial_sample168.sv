module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Continuous assignment of AND operation to out_assign
assign out_assign = a & b;

// Combinational always block for AND operation to out_alwaysblock
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule