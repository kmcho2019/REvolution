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

    // Select one of the 16 multiplexers using the most significant 4 bits of the select signal
    wire [15:0] mux_out;
    wire [3:0] mux_sel = sel[7:4];
    assign mux_out = group[mux_sel];

    // Select one bit from the output of the chosen multiplexer using the least significant 4 bits of the select signal
    wire [3:0] bit_sel = sel[3:0];
    assign out = mux_out[bit_sel];

endmodule