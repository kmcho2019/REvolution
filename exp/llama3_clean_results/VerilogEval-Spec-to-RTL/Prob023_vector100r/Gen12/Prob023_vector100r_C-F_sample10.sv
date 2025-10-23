module TopModule #(
    parameter WIDTH = 100
) (
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

    // Parameterizable module for handling inputs of varying sizes
    genvar i;
    generate
        // Using a generate block to efficiently reverse the input bits
        for (i = 0; i < WIDTH; i++) begin
            assign out[WIDTH - 1 - i] = in[i];
        end
    endgenerate

endmodule