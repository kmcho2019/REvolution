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

    wire [29:0] inputs_concat = {a, b, c, d, e, f};  // 6*5=30 bits

    wire [31:0] combined = {inputs_concat, 2'b11};   // append two '1' bits at LSBs

    assign {w, x, y, z} = combined;

endmodule