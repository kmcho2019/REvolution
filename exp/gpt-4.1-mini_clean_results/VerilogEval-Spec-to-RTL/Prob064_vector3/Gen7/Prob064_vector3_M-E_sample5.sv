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

    wire [31:0] packed;

    // Pack inputs from MSB to LSB, then append 2'b11 at LSB
    assign packed = {a, b, c, d, e, f, 2'b11};

    // Slice the packed vector into outputs
    assign w = packed[31:24];
    assign x = packed[23:16];
    assign y = packed[15:8];
    assign z = packed[7:0];

endmodule