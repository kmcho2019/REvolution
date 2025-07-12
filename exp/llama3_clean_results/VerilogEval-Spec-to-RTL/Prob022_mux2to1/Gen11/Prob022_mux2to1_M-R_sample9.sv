module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);

always @(*) begin
    out = sel? b : a;
end

endmodule