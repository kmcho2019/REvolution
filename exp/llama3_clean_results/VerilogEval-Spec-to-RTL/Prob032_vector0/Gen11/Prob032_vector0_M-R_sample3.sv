module TopModule(
    input  wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

// Use an always block with a sensitivity list to mimic the assign behavior
always @(*) begin
    outv = vec; // Directly assign the input vector to the output vector
    o2 = vec[2]; // Bit-wise assignments for the individual output bits
    o1 = vec[1];
    o0 = vec[0];
end

endmodule