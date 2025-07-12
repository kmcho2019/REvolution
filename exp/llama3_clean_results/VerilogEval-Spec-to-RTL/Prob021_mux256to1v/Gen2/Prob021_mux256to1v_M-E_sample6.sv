module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Divide the 256 4-bit inputs into 16 groups of 16 inputs each
wire [3:0] group_out [15:0];

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        // Select one input from each group based on the 4 least significant bits of the select signal
        mux16_to_1 mux_group(
            .in(in[i*64 +: 64]),
            .sel(sel[3:0]),
            .out(group_out[i])
        );
    end
endgenerate

// Select the final output based on the 4 most significant bits of the select signal
mux16_to_1 mux_final(
    .in({group_out[15], group_out[14], group_out[13], group_out[12], group_out[11], group_out[10], group_out[9], group_out[8], group_out[7], group_out[6], group_out[5], group_out[4], group_out[3], group_out[2], group_out[1], group_out[0]}),
    .sel(sel[7:4]),
    .out(out)
);

endmodule

// 16-to-1 multiplexer module
module mux16_to_1(
    input  [63:0] in,
    input  [3:0] sel,
    output [3:0] out
);

assign out = in[(sel * 4) +: 4];

endmodule