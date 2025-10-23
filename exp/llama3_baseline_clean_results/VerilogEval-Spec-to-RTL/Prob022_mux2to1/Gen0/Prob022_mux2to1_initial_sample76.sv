module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

always @(*) begin
    out = sel ? b : a;
end

endmodule