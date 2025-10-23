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
    // Concatenate inputs into a single 30-bit vector in order a..f
    wire [29:0] concatenated = {a, b, c, d, e, f};

    // Shift left by 2 bits to make room for two '1' bits in LSB positions
    wire [31:0] shifted = {concatenated, 2'b00};

    // OR with 2'b11 to set two LSBs to '1'
    wire [31:0] combined = shifted | 32'b11;

    // Slice into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule