module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Concatenate inputs directly into a 30-bit vector
    wire [29:0] concat_inputs = {a, b, c, d, e, f};

    // Assign outputs by slicing the concatenated inputs with appended two LSB '1' bits
    // final 32 bits: {concat_inputs[29:0], 2'b11}
    assign w = {concat_inputs[29:22]};                    // bits 31:24
    assign x = concat_inputs[21:14];                       // bits 23:16
    assign y = concat_inputs[13:6];                        // bits 15:8
    assign z = {concat_inputs[5:0], 2'b11};                // bits 7:0 (last 6 bits + 2 appended 1's)

endmodule