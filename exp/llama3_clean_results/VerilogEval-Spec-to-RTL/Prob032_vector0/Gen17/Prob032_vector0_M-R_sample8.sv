module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

always @(*) begin
    // Assign the input vector to the output vector
    outv = vec;
    
    // Assign individual bits of the input vector to output bits
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
end

endmodule