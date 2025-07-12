module TopModule #(
    parameter VECTOR_SIZE = 3
) (
    input  [VECTOR_SIZE-1:0] vec,
    output [VECTOR_SIZE-1:0] outv,
    output [VECTOR_SIZE-1:0] individual_bits
);

assign outv = vec;

generate
    for (genvar i = 0; i < VECTOR_SIZE; i++) begin
        assign individual_bits[i] = vec[i];
    end
endgenerate

endmodule

module top(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);
    wire [2:0] individual_bits;
    TopModule #(.VECTOR_SIZE(3)) top_module(
        .vec(vec),
        .outv(outv),
        .individual_bits(individual_bits)
    );
    assign o2 = individual_bits[2];
    assign o1 = individual_bits[1];
    assign o0 = individual_bits[0];
endmodule