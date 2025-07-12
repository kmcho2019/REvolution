// Refactored TopModule with integrated comparison logic
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Direct assignments for vec1 and vec2
    wire [4:0] vec1 = {a, b, c, d, e};
    wire [4:0] vec2 = {a, b, c, d, e};

    // Integrated comparison logic using generate loop
    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            assign out[i] = ~(vec1[i / 5] ^ vec2[i % 5]);
        end
    endgenerate

endmodule