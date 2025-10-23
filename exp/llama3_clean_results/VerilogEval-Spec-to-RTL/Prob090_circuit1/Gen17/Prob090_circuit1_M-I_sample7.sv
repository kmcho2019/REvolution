module TopModule(
    input  logic a,
    input  logic b,
    output logic q
);

always_comb begin
    q = a & b;
end

endmodule