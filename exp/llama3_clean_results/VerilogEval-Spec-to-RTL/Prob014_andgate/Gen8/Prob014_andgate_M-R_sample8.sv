module TopModule(
    input  logic a,
    input  logic b,
    output logic out
);

always_comb begin
    out = a & b;
end

endmodule