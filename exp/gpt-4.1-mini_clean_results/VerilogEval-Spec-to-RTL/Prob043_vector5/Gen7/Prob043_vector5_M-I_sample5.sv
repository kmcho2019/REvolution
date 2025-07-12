module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_array = {a, b, c, d, e};  // Inputs in order a=MSB to e=LSB
    
    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : out_loop
            // Calculate row i and col j
            // idx = 5*i + j
            // To match output bit numbering:
            // out[24 - idx] = XNOR(in_array[4 - i], in_array[4 - j])
            wire [2:0] i = idx / 5;
            wire [2:0] j = idx % 5;
            // Using Verilog integer division and mod in generate is not standard, so do with functions:
            // We do the math statically below.
            assign out[24 - idx] = ~(in_array[4 - i] ^ in_array[4 - j]);
        end
    endgenerate
endmodule