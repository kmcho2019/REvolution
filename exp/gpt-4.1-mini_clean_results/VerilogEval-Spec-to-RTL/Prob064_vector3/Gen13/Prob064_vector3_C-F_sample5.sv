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

    // Define a constant for the appended two LSB bits '11' to improve clarity
    localparam [1:0] APPENDED_BITS = 2'b11;

    // Concatenate inputs and appended bits into a single 32-bit vector
    wire [31:0] combined = {a, b, c, d, e, f, APPENDED_BITS};

    // Explicitly assign slices of the combined vector to outputs for clear mapping
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule