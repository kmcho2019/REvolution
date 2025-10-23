// Refactored TopModule with direct AND gate implementation
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Direct assign statement for out_assign
assign out_assign = a & b;

// Combinational always block for out_alwaysblock
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule