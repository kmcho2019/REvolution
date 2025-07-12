module TopModule(
    input  wire [31:0] in,  // Input vector
    output wire [31:0] out  // Output vector with bytes reversed
);

    // Internal wire to hold the intermediate result
    wire [31:0] reversed;

    // Byte reversal using shift operations
    assign reversed = {in[7:0], in[15:8], in[23:16], in[31:24]};

    // Alternatively, for a more parameterizable and scalable approach:
    // parameter WIDTH = 32,  // Total width of the vector
    // parameter NUM_BYTES = WIDTH / 8  // Number of bytes in the vector

    // genvar i;
    // generate
    //     for (i = 0; i < NUM_BYTES; i++) begin
    //         assign out[(NUM_BYTES - 1 - i) * 8 +: 8] = in[i * 8 +: 8];
    //     end
    // endgenerate

    assign out = reversed;

endmodule