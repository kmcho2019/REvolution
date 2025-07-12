module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

always @(*) begin
    outv = vec;
    o2 = outv[2];
    o1 = outv[1];
    o0 = outv[0];
end

endmodule