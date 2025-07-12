module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Direct AND implementation using assign statement
assign out_assign = a & b;

// Combinational always block implementing AND operation
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule