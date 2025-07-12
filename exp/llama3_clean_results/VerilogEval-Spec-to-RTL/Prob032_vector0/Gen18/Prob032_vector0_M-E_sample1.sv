module TopModule #(
    parameter vec_size = 3
)(
    input  [vec_size-1:0] vec,
    output [vec_size-1:0] outv,
    output [vec_size-1:0] out_bits
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use a for-loop to generate assignments for output bits
generate
    for (genvar i = 0; i < vec_size; i++) begin
        assign out_bits[i] = vec[i];
    end
endgenerate

endmodule