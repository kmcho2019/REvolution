module TopModule #(
    parameter SIZE = 3
)(
    input  [SIZE-1:0] vec,
    output [SIZE-1:0] outv,
    output [SIZE-1:0] individual_outputs
);

// Directly assign the input vector to the output vector
assign outv = vec;

// Use generate to create individual output bits dynamically
genvar i;
generate
    for (i = 0; i < SIZE; i++) begin
        assign individual_outputs[i] = vec[i];
    end
endgenerate

endmodule

// To match the original interface, instantiate TopModule and assign individual outputs
module TopModuleWrapper(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);
    wire [2:0] individual_outputs;

    TopModule #(.SIZE(3)) top_module(
        .vec(vec),
        .outv(outv),
        .individual_outputs(individual_outputs)
    );

    assign o2 = individual_outputs[2];
    assign o1 = individual_outputs[1];
    assign o0 = individual_outputs[0];

endmodule