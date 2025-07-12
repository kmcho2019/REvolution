module TopModule #(
    parameter VECTOR_SIZE = 3
) (
    input  [VECTOR_SIZE-1:0] vec,
    output [VECTOR_SIZE-1:0] outv,
    output [VECTOR_SIZE-1:0] o
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use a for-loop to generate the individual output bits
genvar i;
generate
    for (i = 0; i < VECTOR_SIZE; i++) begin
        assign o[i] = vec[i];
    end
endgenerate

endmodule