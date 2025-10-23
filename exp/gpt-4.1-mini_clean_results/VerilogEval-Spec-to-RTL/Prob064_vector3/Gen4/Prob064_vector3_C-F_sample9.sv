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

    // Localparam for the two LSB constant ones
    localparam [1:0] CONST_ONES = 2'b11;

    // Concatenate all inputs and append CONST_ONES at LSB to form 32 bits
    wire [31:0] combined = {a, b, c, d, e, f, CONST_ONES};

    // Assign outputs by slicing combined vector, w is MSB chunk, z is LSB
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule