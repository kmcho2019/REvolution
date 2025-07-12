module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Implementing AND gate using assign statement
assign out_assign = a & b;

// Implementing AND gate using combinational always block
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule