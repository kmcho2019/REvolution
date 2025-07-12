module TopModule(
    input  logic a,
    input  logic b,
    output logic out_assign,
    output logic out_alwaysblock
);

// Continuous assignment for out_assign
assign out_assign = a & b;

// Combinational always block for out_alwaysblock
always_comb begin
    out_alwaysblock = a & b;
end

endmodule