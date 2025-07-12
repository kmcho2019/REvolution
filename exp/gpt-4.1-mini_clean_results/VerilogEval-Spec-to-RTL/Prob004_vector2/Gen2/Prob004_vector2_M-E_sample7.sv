module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    wire [7:0] in_bytes [3:0];
    wire [7:0] out_bytes [3:0];

    // Slice input into bytes
    assign in_bytes[0] = in[7:0];
    assign in_bytes[1] = in[15:8];
    assign in_bytes[2] = in[23:16];
    assign in_bytes[3] = in[31:24];

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : byte_reverse
            assign out_bytes[i] = in_bytes[3 - i];
        end
    endgenerate

    // Concatenate reversed bytes
    assign out = {out_bytes[3], out_bytes[2], out_bytes[1], out_bytes[0]};
endmodule