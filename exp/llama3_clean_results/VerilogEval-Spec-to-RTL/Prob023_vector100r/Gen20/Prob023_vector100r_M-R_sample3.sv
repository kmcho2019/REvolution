module TopModule(
    input [99:0] in,
    output [99:0] out
);

    // Use a for-loop to generate the bit reversal logic
    genvar i;
    generate
        for (i = 0; i <= 99; i++) begin
            assign out[i] = in[99 - i];
        end
    endgenerate

endmodule