module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector and individual bits within an always block
always @(*) begin
    outv = vec;
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
end

endmodule