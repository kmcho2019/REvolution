module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Declare partial sums
    wire [4:0] counts_8 [30:0]; // 31 chunks of 8 bits max count = 8 (3 bits needed)
    wire [3:0] count_7;         // 7 bits max count = 7 (3 bits needed)

    genvar i;
    generate
        // 31 chunks of 8 bits each
        for (i = 0; i < 31; i = i + 1) begin : chunk8
            assign counts_8[i] = in[i*8 +: 8] 
                                // population count via reduction operator on bits, sum the bits
                                ? $countones(in[i*8 +: 8]) : 0;
        end
    endgenerate

    // For Verilog-2001 compatible, since $countones is SystemVerilog only,
    // replace $countones by reduction operator + sum of bits (manual)
    // But since $countones may not be supported, we do manual sum:

    // Instead, let's use the built-in reduction operator plus sum by adding bits in parallel:

endmodule