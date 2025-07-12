module TopModule(
    input  [99:0] in,
    output [99:0] out
);

// Use a generate block for concise and efficient bit reversal
genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // Directly assign each output bit to the corresponding reversed input bit
        assign out[i] = in[99 - i];
    end
endgenerate

endmodule