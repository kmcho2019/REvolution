module TopModule(
    input logic a,
    input logic b,
    input logic c,
    output logic out
);
assign out = (a || b || c) ? 1'b1 : 1'b0;
endmodule