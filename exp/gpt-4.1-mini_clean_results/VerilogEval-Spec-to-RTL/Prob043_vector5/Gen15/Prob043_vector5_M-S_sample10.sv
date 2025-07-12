module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    genvar i, j;
    generate
        for (i = 4; i >= 0; i = i - 1) begin : gen_i
            for (j = 4; j >= 0; j = j - 1) begin : gen_j
                // Calculate bit index: (4 - i)*5 + (4 - j) counts from 0 to 24
                // We want out[24] = inputs[4]~^inputs[4], so bit_index = (4 - i)*5 + (4 - j)
                // But we need to map so that out[24] = inputs[4]~^inputs[4], out[0]=inputs[0]~^inputs[0]
                // We define idx = (4 - i)*5 + (4 - j), so out[24 - idx]
                localparam int idx = (4 - i)*5 + (4 - j);
                assign out[24 - idx] = inputs[i] ~^ inputs[j];
            end
        end
    endgenerate
endmodule