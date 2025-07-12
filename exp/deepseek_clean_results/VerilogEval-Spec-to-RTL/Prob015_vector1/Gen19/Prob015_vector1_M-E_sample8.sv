module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    genvar i;
    generate
        // Connect upper byte (bits 15:8) to out_hi
        for (i = 0; i < 8; i = i + 1) begin : upper_byte
            assign out_hi[i] = in[i+8];
        end
        
        // Connect lower byte (bits 7:0) to out_lo
        for (i = 0; i < 8; i = i + 1) begin : lower_byte
            assign out_lo[i] = in[i];
        end
    endgenerate

endmodule