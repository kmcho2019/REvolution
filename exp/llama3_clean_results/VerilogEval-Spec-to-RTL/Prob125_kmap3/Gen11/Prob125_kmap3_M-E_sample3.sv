module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*) begin
    if (a) begin
        out = 1;
    end else if (~b && c) begin
        out = 1;
    end else begin
        out = 0;
    end
end

endmodule