module TopModule #
(
    parameter NUM_BYTES = 4
)
(
    input  wire [NUM_BYTES*8-1:0] in,  // Input vector with NUM_BYTES bytes
    output wire [NUM_BYTES*8-1:0] out  // Output vector with bytes reversed
);

    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i++) begin
            assign out[i*8 +: 8] = in[(NUM_BYTES-1-i)*8 +: 8];
        end
    endgenerate

endmodule