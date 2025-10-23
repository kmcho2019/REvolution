module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Use an always block to continuously assign the output
always @(*) begin
    out = sel ? b : a;
end
endmodule