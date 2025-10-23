module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

logic ab_or, cd_or;

always_comb begin
    ab_or = a | b;
    cd_or = c | d;
    q = ab_or & cd_or;
end

endmodule