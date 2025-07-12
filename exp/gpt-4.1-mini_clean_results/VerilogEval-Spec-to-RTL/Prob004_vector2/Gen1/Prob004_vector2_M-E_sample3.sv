module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    genvar i;
    wire [7:0] in_bytes [3:0];
    wire [7:0] out_bytes [3:0];

    // Split input vector into bytes
    generate
        for (i = 0; i < 4; i = i + 1) begin : split_bytes
            assign in_bytes[i] = in[8*i +: 8];
        end
    endgenerate

    // Reverse the bytes
    generate
        for (i = 0; i < 4; i = i + 1) begin : reverse_bytes
            assign out_bytes[i] = in_bytes[3 - i];
        end
    endgenerate

    // Concatenate reversed bytes into output vector
    assign out = {out_bytes[3], out_bytes[2], out_bytes[1], out_bytes[0]};

endmodule