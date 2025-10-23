module TopModule(
    input logic a,
    input logic b,
    input logic c,
    input logic d,
    output logic q
);

logic ab_or, cd_or;

assign ab_or = a || b;
assign cd_or = c || d;

assign q = ab_or && cd_or;

endmodule