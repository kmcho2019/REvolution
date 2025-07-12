module TopModule(
    input  a,
    input  b,
    input  c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

always @(*) begin
    w = a;
    x = b;
    y = b;
    z = c;
end

endmodule