module TopModule(
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b; // Using assign statement for continuous assignment

always @(*) begin // Combinational always block
    out_alwaysblock = a & b; // Using combinational always block
end

endmodule