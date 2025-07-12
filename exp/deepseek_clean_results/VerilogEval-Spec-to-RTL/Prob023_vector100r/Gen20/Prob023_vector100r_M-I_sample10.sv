module TopModule (
    input  [99:0] in,
    input        en,    // Enable signal for power optimization
    output [99:0] out
);

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : bit_reverse
        assign out[i] = en ? in[99-i] : 1'b0;  // Output 0 when disabled to save power
    end
endgenerate

endmodule