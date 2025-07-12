module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
wire [7:0] bytes [3:0];

// Split input into bytes
generate
    for (i = 0; i < 4; i = i + 1) begin : split_bytes
        assign bytes[i] = in[i*8 +: 8];
    end
endgenerate

// Reverse bytes into output
generate
    for (i = 0; i < 4; i = i + 1) begin : reverse_bytes
        assign out[i*8 +: 8] = bytes[3 - i];
    end
endgenerate

endmodule