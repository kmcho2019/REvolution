module TopModule (
    input [7:0] in,
    output [7:0] out
);
    // Direct bit reversal using generate loop for scalability
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : reverse_bits
            assign out[i] = in[7-i];
        end
    endgenerate
endmodule