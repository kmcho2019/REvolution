module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    // Generate all 25 comparisons in a single vector
    wire [24:0] comparisons;
    assign comparisons = {
        ~(inputs[0] ^ inputs[0]), ~(inputs[0] ^ inputs[1]), ~(inputs[0] ^ inputs[2]), ~(inputs[0] ^ inputs[3]), ~(inputs[0] ^ inputs[4]),
        ~(inputs[1] ^ inputs[0]), ~(inputs[1] ^ inputs[1]), ~(inputs[1] ^ inputs[2]), ~(inputs[1] ^ inputs[3]), ~(inputs[1] ^ inputs[4]),
        ~(inputs[2] ^ inputs[0]), ~(inputs[2] ^ inputs[1]), ~(inputs[2] ^ inputs[2]), ~(inputs[2] ^ inputs[3]), ~(inputs[2] ^ inputs[4]),
        ~(inputs[3] ^ inputs[0]), ~(inputs[3] ^ inputs[1]), ~(inputs[3] ^ inputs[2]), ~(inputs[3] ^ inputs[3]), ~(inputs[3] ^ inputs[4]),
        ~(inputs[4] ^ inputs[0]), ~(inputs[4] ^ inputs[1]), ~(inputs[4] ^ inputs[2]), ~(inputs[4] ^ inputs[3]), ~(inputs[4] ^ inputs[4])
    };

    // out[24] = a vs a = inputs[0] vs inputs[0], so reverse the comparisons vector order to match problem bit numbering
    assign out = {comparisons[24], comparisons[23], comparisons[22], comparisons[21], comparisons[20],
                  comparisons[19], comparisons[18], comparisons[17], comparisons[16], comparisons[15],
                  comparisons[14], comparisons[13], comparisons[12], comparisons[11], comparisons[10],
                  comparisons[9],  comparisons[8],  comparisons[7],  comparisons[6],  comparisons[5],
                  comparisons[4],  comparisons[3],  comparisons[2],  comparisons[1],  comparisons[0]};
endmodule