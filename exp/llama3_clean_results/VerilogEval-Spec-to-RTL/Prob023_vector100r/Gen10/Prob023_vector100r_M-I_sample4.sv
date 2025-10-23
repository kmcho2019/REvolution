module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Use a for loop to reverse the bits, maintaining scalability and efficiency
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // Directly assign each output bit to the corresponding reversed input bit
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate

endmodule