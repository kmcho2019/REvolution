module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

logic temp;

always @(*) begin
    temp = b | c;
    if (a) begin
        out = 1'b1;
    end else begin
        out = temp;
    end
end

endmodule