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

    // Intermediate 15-bit wires for hierarchical concatenation clarity
    wire [14:0] first_half  = {a, b, c};
    wire [14:0] second_half = {d, e, f};
    
    // Concatenate both halves and append constant 2'b11 LSB to form 32-bit vector
    wire [31:0] combined = {first_half, second_half, 2'b11};

    // Explicitly slice 'combined' to outputs for clear bit mapping
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule