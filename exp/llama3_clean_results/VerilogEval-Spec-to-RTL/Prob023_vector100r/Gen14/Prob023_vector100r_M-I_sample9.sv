module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // Explicitly buffering the output might help in some technologies
            // However, this is technology-dependent and may not always be beneficial
            assign out[WIDTH - 1 - i] = in[i];
        end
    endgenerate

endmodule