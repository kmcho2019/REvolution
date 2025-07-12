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

    // Group inputs into two 15-bit wires for readability and modularity
    wire [14:0] group1 = {a, b, c};  // 15 bits
    wire [14:0] group2 = {d, e, f};  // 15 bits

    // Concatenate groups and append two LSB '1' bits to form 32-bit vector
    wire [31:0] combined = {group1, group2, 2'b11};

    // Assign 8-bit output slices directly from combined vector
    assign {w, x, y, z} = combined;

endmodule