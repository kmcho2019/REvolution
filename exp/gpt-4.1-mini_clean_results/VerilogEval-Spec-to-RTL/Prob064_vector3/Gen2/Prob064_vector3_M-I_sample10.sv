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

    localparam [1:0] CONST_BITS = 2'b11;

    wire [31:0] combined;

    // Place constant bits at the MSB side to reduce glitching and improve power
    assign combined = {CONST_BITS, a, b, c, d, e, f};

    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule