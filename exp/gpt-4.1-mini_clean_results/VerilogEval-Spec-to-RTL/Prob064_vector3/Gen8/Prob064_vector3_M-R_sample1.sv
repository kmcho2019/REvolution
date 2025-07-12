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

    // Concatenate inputs and two '1' bits in the LSB positions
    wire [31:0] concat_all;
    assign concat_all = {a, b, c, d, e, f, 2'b11};

    // Slice outputs from the concatenated wire
    assign w = concat_all[31:24];
    assign x = concat_all[23:16];
    assign y = concat_all[15:8];
    assign z = concat_all[7:0];

endmodule