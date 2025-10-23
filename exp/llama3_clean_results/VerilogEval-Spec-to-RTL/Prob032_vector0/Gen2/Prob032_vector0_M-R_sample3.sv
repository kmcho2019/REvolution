module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

always @(*) begin
    outv = vec;
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
end

endmodule