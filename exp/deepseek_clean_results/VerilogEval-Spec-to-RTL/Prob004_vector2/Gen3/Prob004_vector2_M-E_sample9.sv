module TopModule #(
    parameter BYTE_WIDTH = 8,
    parameter NUM_BYTES = 4
) (
    input  [BYTE_WIDTH*NUM_BYTES-1:0] in,
    output [BYTE_WIDTH*NUM_BYTES-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < NUM_BYTES; i = i + 1) begin : byte_swap
            assign out[BYTE_WIDTH*(NUM_BYTES-i)-1 -: BYTE_WIDTH] = 
                   in[BYTE_WIDTH*(i+1)-1 -: BYTE_WIDTH];
        end
    endgenerate
endmodule