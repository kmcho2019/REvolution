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

    // Directly assign outputs by slicing the concatenated inputs and appended bits
    assign w = {a, b[4:1]};             // 5 bits from a and top 4 bits of b = 8 bits
    assign x = {b[0], c, d[4]};         // last bit of b + 5 bits c + top bit of d = 8 bits
    assign y = {d[3:0], e[4:2]};        // bits 3:0 of d + top 3 bits of e = 8 bits
    assign z = {e[1:0], f, 2'b11};      // lower 2 bits of e + 5 bits f + appended two '1' bits

endmodule