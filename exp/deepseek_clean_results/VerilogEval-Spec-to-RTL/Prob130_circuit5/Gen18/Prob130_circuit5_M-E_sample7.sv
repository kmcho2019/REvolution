module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Bit-sliced implementation
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin: bit_slice
        // Priority-encoded selection
        assign q[i] = (c[1:0] == 2'b00) ? b[i] :
                     ((c[1:0] == 2'b01) ? e[i] :
                     ((c[1:0] == 2'b10) ? a[i] :
                     ((c[1:0] == 2'b11) ? d[i] : 1'b1));
    end
endgenerate

endmodule