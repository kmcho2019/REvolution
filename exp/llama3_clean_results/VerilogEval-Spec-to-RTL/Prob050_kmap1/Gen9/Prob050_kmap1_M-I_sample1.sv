module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

always @(*) begin
    out = a || (b | c);
end

endmodule