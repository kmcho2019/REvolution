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

    // Directly combine all inputs plus two LSB bits set to '1'
    wire [31:0] combined = {a, b, c, d, e, f, 2'b11};

    // Assign outputs by shifting and masking instead of slice notation
    assign w = (combined >> 24) & 8'hFF;
    assign x = (combined >> 16) & 8'hFF;
    assign y = (combined >> 8)  & 8'hFF;
    assign z = combined         & 8'hFF;

endmodule