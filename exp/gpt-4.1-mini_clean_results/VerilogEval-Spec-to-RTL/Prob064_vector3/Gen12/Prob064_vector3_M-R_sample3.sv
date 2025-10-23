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

    reg [31:0] combined;

    always @(*) begin
        combined = {a, b, c, d, e, f, 2'b11};
        {w, x, y, z} = combined;
    end

endmodule