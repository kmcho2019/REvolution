module TopModule #(
    parameter BYTE_WIDTH = 8,
    parameter NUM_BYTES = 4
) (
    input  wire [BYTE_WIDTH*NUM_BYTES-1:0] in,
    output wire [BYTE_WIDTH*NUM_BYTES-1:0] out
);

genvar i;
generate
    for (i = 0; i < NUM_BYTES; i = i + 1) begin : byte_reverse
        assign out[BYTE_WIDTH*(i+1)-1 : BYTE_WIDTH*i] = in[BYTE_WIDTH*(NUM_BYTES - 1 - i + 1)-1 : BYTE_WIDTH*(NUM_BYTES - 1 - i)];
    end
endgenerate

endmodule