module TopModule (
    input  [31:0] in,
    output [31:0] out
);

localparam BYTE_CNT = 4;

wire [7:0] bytes [BYTE_CNT-1:0];

genvar i;
generate
    for (i = 0; i < BYTE_CNT; i = i + 1) begin : byte_extract
        assign bytes[i] = in[(i*8) +: 8];
    end
endgenerate

assign out = {bytes[0], bytes[1], bytes[2], bytes[3]}[::-1]; // This is invalid in Verilog, so instead:

// Since Verilog has no reverse concatenation operator, do it explicitly:
assign out = {bytes[BYTE_CNT-1], bytes[BYTE_CNT-2], bytes[BYTE_CNT-3], bytes[BYTE_CNT-4]};

endmodule