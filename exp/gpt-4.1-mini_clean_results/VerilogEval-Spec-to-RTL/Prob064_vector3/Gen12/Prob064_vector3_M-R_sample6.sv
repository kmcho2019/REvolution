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
        combined = {a, b, c, d, e, f, 2'b11}; // Concatenate inputs + two LSB '1's
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end

endmodule