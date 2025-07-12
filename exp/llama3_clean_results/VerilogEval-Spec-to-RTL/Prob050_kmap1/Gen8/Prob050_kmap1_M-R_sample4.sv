module TopModule(
    input a,
    input b,
    input c,
    output reg out
);

always @(*) begin
    if (a) begin
        out = 1'b1;
    end else begin
        out = b | c;
    end
end

endmodule