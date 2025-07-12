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

    // Zero-extend each 5-bit input to 8 bits (pad 3 MSBs with zeros)
    wire [7:0] a8 = {3'b000, a};
    wire [7:0] b8 = {3'b000, b};
    wire [7:0] c8 = {3'b000, c};
    wire [7:0] d8 = {3'b000, d};
    wire [7:0] e8 = {3'b000, e};
    wire [7:0] f8 = {3'b000, f};

    // Concatenate all zero-extended inputs into a 48-bit vector
    wire [47:0] extended_concat = {a8, b8, c8, d8, e8, f8};

    // Select bits to form a 32-bit vector: take the first 30 bits of extended_concat,
    // then append two '1' bits at LSB
    wire [31:0] out_vector;
    assign out_vector[31:2] = extended_concat[47:18]; // top 30 bits from 6*8 bits inputs (discarding extra padding bits)
    assign out_vector[1:0] = 2'b11;

    // Assign outputs as slices of out_vector
    assign w = out_vector[31:24];
    assign x = out_vector[23:16];
    assign y = out_vector[15:8];
    assign z = out_vector[7:0];

endmodule