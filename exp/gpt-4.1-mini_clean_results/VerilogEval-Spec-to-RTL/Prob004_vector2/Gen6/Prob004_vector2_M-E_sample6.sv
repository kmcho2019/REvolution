module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Define byte arrays for input and output
    wire [7:0] in_bytes [3:0];
    wire [7:0] out_bytes [3:0];

    // Assign input vector to byte array slices
    assign {in_bytes[3], in_bytes[2], in_bytes[1], in_bytes[0]} = in;

    genvar i;
    generate
        // Reverse the bytes using a generate loop
        for (i = 0; i < 4; i = i + 1) begin : byte_reverse
            assign out_bytes[i] = in_bytes[3 - i];
        end
    endgenerate

    // Concatenate output byte array into output vector
    assign out = {out_bytes[3], out_bytes[2], out_bytes[1], out_bytes[0]};

endmodule