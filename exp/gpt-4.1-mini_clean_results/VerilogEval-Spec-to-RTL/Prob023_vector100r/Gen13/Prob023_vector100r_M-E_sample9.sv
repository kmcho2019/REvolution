module BitRev10 (
    input  wire [9:0] in,
    output wire [9:0] out
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : bit_rev_10
            assign out[i] = in[9 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Declare intermediate wires for reversed 10-bit blocks
    wire [9:0] blocks_in  [0:9];
    wire [9:0] blocks_out [0:9];

    genvar j;
    generate
        for (j = 0; j < 10; j = j + 1) begin : block_process
            assign blocks_in[j] = in[ (j*10) + 9 : j*10 ];
            BitRev10 bitrev10_inst (
                .in(blocks_in[j]),
                .out(blocks_out[j])
            );
        end
    endgenerate

    // Concatenate reversed blocks in reversed block order to form the output
    assign out = {
        blocks_out[0],
        blocks_out[1],
        blocks_out[2],
        blocks_out[3],
        blocks_out[4],
        blocks_out[5],
        blocks_out[6],
        blocks_out[7],
        blocks_out[8],
        blocks_out[9]
    };

    // But we need to reverse the block order, so redefine output assignment:
    // Since concatenation lists blocks_out[0] as MSB down to blocks_out[9] as LSB,
    // reverse the order instead:

    wire [99:0] reversed_concat;
    assign reversed_concat = {
        blocks_out[9],
        blocks_out[8],
        blocks_out[7],
        blocks_out[6],
        blocks_out[5],
        blocks_out[4],
        blocks_out[3],
        blocks_out[2],
        blocks_out[1],
        blocks_out[0]
    };
    assign out = reversed_concat;
endmodule