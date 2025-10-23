module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    always @(*) begin
        // w gets a (5 bits) plus top 3 bits of b (bits 4:2)
        w = {a, b[4:2]};
    end

    always @(*) begin
        // x gets bottom 2 bits of b plus c (5 bits) plus top 1 bit of d
        x = {b[1:0], c, d[4]};
    end

    always @(*) begin
        // y gets bottom 4 bits of d plus e (5 bits) (we need to fill 8 bits, take d[3:0], e[4:1])
        y = {d[3:0], e[4:1]};
    end

    always @(*) begin
        // z gets bottom bit of e, all f bits, plus two appended '1' bits at LSB
        // e[0], f[4:0], and two 1's appended at LSB -> total 8 bits
        z = {e[0], f, 2'b11};
    end

endmodule