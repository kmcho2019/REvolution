module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Using assign statement for continuous assignment
assign out_assign = a & b;

// Using combinational always block for procedural assignment
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule