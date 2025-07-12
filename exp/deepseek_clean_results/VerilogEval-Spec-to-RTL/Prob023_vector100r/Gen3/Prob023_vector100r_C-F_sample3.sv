module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Bit-reversal using generate loop for scalability and parameterized width for flexibility
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse
            localparam integer REV_IDX = WIDTH - 1 - i;
            assign out[i] = in[REV_IDX];
        end
    endgenerate

endmodule