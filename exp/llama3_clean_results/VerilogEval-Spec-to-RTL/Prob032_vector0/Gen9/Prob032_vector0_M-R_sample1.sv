module TopModule(
    input  wire logic [2:0] vec,
    output wire logic [2:0] outv,
    output wire logic o2,
    output wire logic o1,
    output wire logic o0
);

// Procedural assignment within an always block
always @(*) begin
    // Assign the input vector to the output vector
    outv = vec;
    
    // Use bit-wise assignments for the individual output bits
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
end

endmodule