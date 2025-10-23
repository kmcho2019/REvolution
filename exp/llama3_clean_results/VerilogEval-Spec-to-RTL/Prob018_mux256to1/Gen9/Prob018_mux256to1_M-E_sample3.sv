module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the input vector into 16 groups of 16 bits
    wire [15:0] group [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Create a decoder to generate one-hot encoded signal
    wire [15:0] decoder_out;
    always @(*) begin
        decoder_out = 16'b0;
        decoder_out[sel[7:4]] = 1'b1;
    end

    // Create 16 16-to-1 multiplexers
    wire [15:0] mux_out [15:0];
    genvar j;
    generate
        for (j = 0; j < 16; j++) begin
            assign mux_out[j] = group[j][sel[3:0]];
        end
    endgenerate

    // Use the one-hot encoded signal to enable the corresponding multiplexer
    wire or_out;
    assign or_out = (decoder_out[0] && mux_out[0]) ||
                    (decoder_out[1] && mux_out[1]) ||
                    (decoder_out[2] && mux_out[2]) ||
                    (decoder_out[3] && mux_out[3]) ||
                    (decoder_out[4] && mux_out[4]) ||
                    (decoder_out[5] && mux_out[5]) ||
                    (decoder_out[6] && mux_out[6]) ||
                    (decoder_out[7] && mux_out[7]) ||
                    (decoder_out[8] && mux_out[8]) ||
                    (decoder_out[9] && mux_out[9]) ||
                    (decoder_out[10] && mux_out[10]) ||
                    (decoder_out[11] && mux_out[11]) ||
                    (decoder_out[12] && mux_out[12]) ||
                    (decoder_out[13] && mux_out[13]) ||
                    (decoder_out[14] && mux_out[14]) ||
                    (decoder_out[15] && mux_out[15]);

    // Assign the final output
    assign out = or_out;

endmodule