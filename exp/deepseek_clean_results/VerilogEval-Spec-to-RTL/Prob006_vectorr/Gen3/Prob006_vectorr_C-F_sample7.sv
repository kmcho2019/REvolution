module TopModule #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Ensure positive width
    initial assert(WIDTH > 0) else $error("WIDTH must be positive");

    // Reverse bits using concatenation with generate
    generate
        if (WIDTH == 8) begin : optimized_8bit
            assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
        end else begin : generic_case
            for (genvar i = 0; i < WIDTH; i++) begin : reverse_bits
                assign out[i] = in[WIDTH-1-i];
            end
        end
    endgenerate

endmodule