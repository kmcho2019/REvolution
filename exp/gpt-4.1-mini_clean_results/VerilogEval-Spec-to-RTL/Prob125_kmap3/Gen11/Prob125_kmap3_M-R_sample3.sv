module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output reg out
);

always @(*) begin
    if (c == 0) begin
        if (b == 0)
            out = a;
        else
            out = 1'b1;
    end else begin
        if (b == 0)
            out = 1'b1;
        else
            out = a;
    end
end

endmodule