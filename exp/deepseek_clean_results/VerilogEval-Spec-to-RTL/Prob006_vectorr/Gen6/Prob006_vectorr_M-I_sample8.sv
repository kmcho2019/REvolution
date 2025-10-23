module TopModule (
    input [7:0] in,    // 8-bit input
    output [7:0] out   // 8-bit reversed output
);
    // Systematic bit reversal using concatenation
    // Maintains identical PPA to original solution
    assign out = {
        in[0], in[1], in[2], in[3],
        in[4], in[5], in[6], in[7]
    };
    
    /* Alternative parameterized version (same PPA for 8-bit):
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_reverse
            assign out[i] = in[7-i];
        end
    endgenerate
    */
endmodule