module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : bit_processor
            // Local left and right neighbor indices with circular handling
            localparam left = (i == 99) ? 0 : (i + 1);
            localparam right = (i == 0) ? 99 : (i - 1);
            
            // Processing element for each bit
            always @(*) begin
                // out_both: current and left neighbor (special case for MSB)
                out_both[i] = (i == 99) ? 1'b0 : (in[i] & in[left]);
                
                // out_any: current and right neighbor (special case for LSB)
                out_any[i] = (i == 0) ? 1'b0 : (in[i] | in[right]);
                
                // out_different: current and left neighbor with circular wrap
                out_different[i] = in[i] ^ in[left];
            end
        end
    endgenerate

endmodule