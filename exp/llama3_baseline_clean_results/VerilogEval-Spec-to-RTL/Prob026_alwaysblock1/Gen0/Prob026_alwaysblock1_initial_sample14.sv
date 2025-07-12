module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

// Using assign statement for continuous assignment
assign out_assign = a & b;

// Using combinational always block for the same operation
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule