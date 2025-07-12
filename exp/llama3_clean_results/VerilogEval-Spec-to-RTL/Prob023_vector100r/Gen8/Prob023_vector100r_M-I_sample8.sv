module TopModule #(
    parameter WIDTH = 100
) (
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate

endmodule