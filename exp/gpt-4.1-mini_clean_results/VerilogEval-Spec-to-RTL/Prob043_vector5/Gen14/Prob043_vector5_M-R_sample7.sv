module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Pack inputs into a vector for indexed access
    wire [4:0] inputs = {a, b, c, d, e};

    // Assign all 25 pairwise comparisons explicitly using a single assign statement,
    // preserving the output bit order: out[24] = compare(a,a), out[23] = compare(a,b), ..., out[0] = compare(e,e)
    assign out = {
        (inputs[4] ~^ inputs[4]), (inputs[4] ~^ inputs[3]), (inputs[4] ~^ inputs[2]), (inputs[4] ~^ inputs[1]), (inputs[4] ~^ inputs[0]),
        (inputs[3] ~^ inputs[4]), (inputs[3] ~^ inputs[3]), (inputs[3] ~^ inputs[2]), (inputs[3] ~^ inputs[1]), (inputs[3] ~^ inputs[0]),
        (inputs[2] ~^ inputs[4]), (inputs[2] ~^ inputs[3]), (inputs[2] ~^ inputs[2]), (inputs[2] ~^ inputs[1]), (inputs[2] ~^ inputs[0]),
        (inputs[1] ~^ inputs[4]), (inputs[1] ~^ inputs[3]), (inputs[1] ~^ inputs[2]), (inputs[1] ~^ inputs[1]), (inputs[1] ~^ inputs[0]),
        (inputs[0] ~^ inputs[4]), (inputs[0] ~^ inputs[3]), (inputs[0] ~^ inputs[2]), (inputs[0] ~^ inputs[1]), (inputs[0] ~^ inputs[0])
    };

endmodule