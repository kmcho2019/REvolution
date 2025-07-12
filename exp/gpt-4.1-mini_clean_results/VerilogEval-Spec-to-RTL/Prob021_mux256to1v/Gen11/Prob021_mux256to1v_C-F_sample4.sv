module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Represent input as 256 elements of 4 bits each for easy indexing
    wire [3:0] in_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : unpack_input
            assign in_array[i] = in[4*i +: 4];
        end
    endgenerate

    // Select a 16-bit block (4 consecutive 4-bit words) from in_array indexed by sel[7:2]
    // Concatenate the 4 words in descending order (highest index on left) for easier slicing
    wire [15:0] block;
    assign block = {in_array[{sel[7:2], 2'b11}],
                    in_array[{sel[7:2], 2'b10}],
                    in_array[{sel[7:2], 2'b01}],
                    in_array[{sel[7:2], 2'b00}]};

    // Select one 4-bit word inside the 16-bit block with sel[1:0]
    assign out = block[sel[1:0]*4 +: 4];

endmodule