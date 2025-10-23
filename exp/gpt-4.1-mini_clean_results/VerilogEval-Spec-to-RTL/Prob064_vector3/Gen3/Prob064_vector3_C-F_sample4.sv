module TopModule (
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

    wire [29:0] inputs_concat;

    // Concatenate inputs into 30-bit vector
    assign inputs_concat = {a, b, c, d, e, f};

    // Directly assign outputs by slicing the concatenated vector plus two LSB '1' bits
    assign w = {inputs_concat[29:22]};                  // bits 29 downto 22
    assign x = {inputs_concat[21:14]};                  // bits 21 downto 14
    assign y = {inputs_concat[13:6]};                   // bits 13 downto 6
    assign z = {inputs_concat[5:0], 2'b11};              // bits 5 downto 0 + two '1' bits

endmodule