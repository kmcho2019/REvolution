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

    always @* begin
        // Concatenate inputs and append two '1' bits at the LSB
        combined = {a, b, c, d, e, f, 2'b11};
        // Slice the combined vector into outputs
        w = combined[31:24];
        x = combined[23:16];
        y = combined[15:8];
        z = combined[7:0];
    end

endmodule