module TopModule(
    input  in1,
    output out,
    input  in2
);

reg out;

always @(*) begin
    out = ~(in1 | in2);
end

endmodule