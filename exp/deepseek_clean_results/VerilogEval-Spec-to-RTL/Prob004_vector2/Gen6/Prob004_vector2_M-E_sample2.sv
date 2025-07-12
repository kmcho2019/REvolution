module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Direct byte reversal using concatenation with calculated indices
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : byte_reverse
            assign out[(i+1)*8-1:i*8] = in[(4-i)*8-1:(3-i)*8];
        end
    endgenerate
endmodule