module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Continuous assignment
assign out_assign = a & b;

// Combinational always block
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule