module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Create 32-bit intermediate wire with inputs and padding
    wire [31:0] combined = {a, b, c, d, e, f, 2'b11};

    // Assign outputs by selecting appropriate byte slices
    assign w = combined[31:24];  // MSB byte
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];    // LSB byte (contains padding bits)

endmodule