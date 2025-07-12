module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

assign outv = vec;

always @(*) begin
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
end

endmodule