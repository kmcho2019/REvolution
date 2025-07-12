module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

always @(*) begin
    outv = vec;
    {o2, o1, o0} = vec;
end

endmodule