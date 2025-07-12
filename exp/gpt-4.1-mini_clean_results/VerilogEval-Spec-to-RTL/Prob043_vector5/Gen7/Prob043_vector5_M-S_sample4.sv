module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Flatten the 2D indices (i,j) into one index k from 0 to 24
    // For k in [0..24], i = k/5, j = k%5
    genvar k;
    generate
        for (k = 0; k < 25; k = k + 1) begin : gen_pairs
            wire in_i, in_j;
            assign in_i = (k/5 == 0) ? a :
                          (k/5 == 1) ? b :
                          (k/5 == 2) ? c :
                          (k/5 == 3) ? d : e;
            assign in_j = (k%5 == 0) ? a :
                          (k%5 == 1) ? b :
                          (k%5 == 2) ? c :
                          (k%5 == 3) ? d : e;
            // out[24 - k] = equality of inputs[i], inputs[j]
            assign out[24 - k] = ~(in_i ^ in_j);
        end
    endgenerate
endmodule