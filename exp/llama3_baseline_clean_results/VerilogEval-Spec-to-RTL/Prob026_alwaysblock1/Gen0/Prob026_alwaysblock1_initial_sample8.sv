module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Using assign statement for combinational logic
assign out_assign = a & b;

// Using always block for combinational logic
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule