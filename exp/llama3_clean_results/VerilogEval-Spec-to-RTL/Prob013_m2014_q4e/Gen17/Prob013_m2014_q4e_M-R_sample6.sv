module TopModule(
    input  in1,
    input  in2,
    output out
);
always @(*) begin
    out = ~in1 & ~in2;
end
endmodule