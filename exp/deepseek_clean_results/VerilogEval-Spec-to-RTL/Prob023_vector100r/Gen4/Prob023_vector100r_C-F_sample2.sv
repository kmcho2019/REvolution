module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Parameterized bit reversal using generate
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : bit_reverse
        assign out[i] = in[99-i];  // Direct wiring for optimal implementation
    end
endgenerate

endmodule