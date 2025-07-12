module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use an always block for combinational logic
always @(*) begin
    // Directly assign individual bits of the input vector to output bits
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
end

endmodule