module TopModule #(
    parameter VECTOR_LENGTH = 3
)(
    input  [VECTOR_LENGTH-1:0] vec,
    output [VECTOR_LENGTH-1:0] outv,
    output [VECTOR_LENGTH-1:0] o
);

    // Initialize the output vector with the input vector
    assign outv = vec;

    // Use a loop to generate the individual output bits
    genvar i;
    generate
        for (i = 0; i < VECTOR_LENGTH; i++) begin
            assign o[i] = vec[i];
        end
    endgenerate

endmodule

module main(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    wire [2:0] o;

    TopModule #(.VECTOR_LENGTH(3)) top_module(
        .vec(vec),
        .outv(outv),
        .o(o)
    );

    assign o2 = o[2];
    assign o1 = o[1];
    assign o0 = o[0];

endmodule