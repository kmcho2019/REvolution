module TopModule #(
    parameter INPUT_SIZE = 100
) (
    input  [INPUT_SIZE-1:0] in,
    output [INPUT_SIZE-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < INPUT_SIZE; i++) begin
            assign out[INPUT_SIZE - 1 - i] = in[i];
        end
    endgenerate

endmodule