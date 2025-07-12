module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Using assign statement to implement an AND gate
assign out_assign = a & b;

// Using a combinational always block to implement an AND gate
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule