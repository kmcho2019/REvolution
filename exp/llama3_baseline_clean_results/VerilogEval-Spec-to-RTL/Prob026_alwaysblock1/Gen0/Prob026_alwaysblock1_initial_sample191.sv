module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b; // Continuous assignment for AND operation

always @(*) begin // Combinational always block sensitive to all inputs
    out_alwaysblock = a & b; // AND operation within the always block
end

endmodule