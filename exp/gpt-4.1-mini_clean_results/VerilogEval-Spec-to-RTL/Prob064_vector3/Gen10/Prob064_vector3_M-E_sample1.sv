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

    // Stage 1: Concatenate inputs into two 10-bit parts
    wire [9:0] part1 = {a, b};    // 10 bits
    wire [9:0] part2 = {c, d};    // 10 bits
    wire [9:0] part3 = {e, f};    // 10 bits

    // Stage 2: Concatenate the three parts into 30 bits
    wire [29:0] combined = {part1, part2, part3};

    // Stage 3: Append two '1' bits at the LSB positions to make 32 bits
    wire [31:0] full_vector = {combined, 2'b11};

    // Assign the output vectors by slicing full_vector
    assign {w, x, y, z} = full_vector;

endmodule