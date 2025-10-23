module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Split selector into upper and lower nibbles
    wire [3:0] sel_upper = sel[7:4];
    wire [3:0] sel_lower = sel[3:0];

    // Decode upper nibble to 16 group enables
    wire [15:0] group_en;
    decoder_4to16 upper_decoder (
        .in(sel_upper),
        .out(group_en)
    );

    // Generate 256 individual enables
    wire [255:0] input_en;
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : group_decoders
            wire [15:0] local_en;
            decoder_4to16 lower_decoder (
                .in(sel_lower),
                .out(local_en),
                .enable(group_en[i])
            );
            
            // Combine group and local enables
            for (genvar j = 0; j < 16; j = j + 1) begin : input_enables
                assign input_en[i*16 + j] = local_en[j] & group_en[i];
            end
        end
    endgenerate

    // Wired-OR output stage with tri-state buffers
    wire [255:0] tri_out;
    generate
        for (genvar i = 0; i < 256; i = i + 1) begin : output_drivers
            assign tri_out[i] = input_en[i] ? in[i] : 1'bz;
        end
    endgenerate

    // Final wired-OR connection
    assign out = |tri_out;

endmodule

// 4-to-16 decoder with optional enable
module decoder_4to16 (
    input  [3:0] in,
    output [15:0] out,
    input  enable = 1'b1
);
    assign out = enable ? (16'b1 << in) : 16'b0;
endmodule