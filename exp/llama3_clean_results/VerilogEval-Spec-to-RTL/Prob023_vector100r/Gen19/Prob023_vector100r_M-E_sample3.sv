module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // Conceptually similar to a barrel shifter, but directly assigns the reversed bits
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate

endmodule