module TopModule(
    input  wire [2:0] vec,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);

// Use always blocks to assign values to outputs
always @(*) begin
    // Directly assign the input vector to the output vector
    outv = vec;
    
    // Use bit-wise assignments for the individual output bits
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
end

endmodule