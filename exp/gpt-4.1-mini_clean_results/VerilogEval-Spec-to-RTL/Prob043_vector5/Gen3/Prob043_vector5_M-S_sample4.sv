module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    genvar idx;
    generate
        for (idx = 0; idx < 25; idx = idx + 1) begin : compare_loop
            // Compute row (i) and column (j) from idx
            localparam integer i = idx / 5;
            localparam integer j = idx % 5;
            // Assign bit in descending order to match out[24 - idx]
            assign out[24 - idx] = ~(inputs[i] ^ inputs[j]);
        end
    endgenerate
endmodule