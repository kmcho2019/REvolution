module TopModule #(
    parameter WIDTH = 32,
    parameter NUM_BYTES = WIDTH / 8
) (
    input  wire [WIDTH-1:0] in,  // Input vector
    output wire [WIDTH-1:0] out  // Output vector with bytes reversed
);

    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            assign out[(i*8)+:8] = in[(NUM_BYTES-1-i)*8+:8];  // Reverse byte order
        end
    endgenerate

endmodule