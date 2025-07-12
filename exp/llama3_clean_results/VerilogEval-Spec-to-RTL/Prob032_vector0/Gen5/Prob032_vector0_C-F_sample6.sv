module TopModule(
    input  wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

always @(*) begin
    outv = vec;
    {o2, o1, o0} = vec;
end

endmodule