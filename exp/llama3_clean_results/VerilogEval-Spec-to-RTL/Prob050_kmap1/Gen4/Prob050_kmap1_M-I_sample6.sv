module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

always_comb begin
    out = a || b || c;
end

endmodule