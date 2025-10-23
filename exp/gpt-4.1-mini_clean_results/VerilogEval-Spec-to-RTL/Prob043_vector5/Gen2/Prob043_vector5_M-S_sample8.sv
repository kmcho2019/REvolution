module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};  // inputs[4]=a ... inputs[0]=e

    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : compare_loop
            // i, j derived from idx
            wire [2:0] i = idx / 5;
            wire [2:0] j = idx % 5;
            // out bit index matches spec: out[24 - idx]
            assign out[24 - idx] = ~(inputs[i] ^ inputs[j]);
        end
    endgenerate
endmodule