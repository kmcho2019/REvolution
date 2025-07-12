module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Treat input as 256 4-bit words
    wire [3:0] in_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin
            assign in_array[i] = in[4*i +: 4];
        end
    endgenerate

    // Select one 16-bit block (4 consecutive 4-bit words) using upper 6 bits of sel
    wire [15:0] block;
    assign block = {in_array[{sel[7:2], 2'd3}],
                    in_array[{sel[7:2], 2'd2}],
                    in_array[{sel[7:2], 2'd1}],
                    in_array[{sel[7:2], 2'd0}]};

    // Select one 4-bit word inside the block using lower 2 bits of sel
    assign out = block[4*sel[1:0] +: 4];

endmodule