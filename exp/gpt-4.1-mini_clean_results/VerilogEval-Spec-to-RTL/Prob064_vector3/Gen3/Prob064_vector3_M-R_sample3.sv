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
    wire [31:0] with_ones;

    assign inputs_concat = {a, b, c, d, e, f};        // 30 bits concatenated
    assign with_ones = {inputs_concat, 2'b11};        // Append two '1's at LSB

    assign w = with_ones[31:24];
    assign x = with_ones[23:16];
    assign y = with_ones[15:8];
    assign z = with_ones[7:0];

endmodule