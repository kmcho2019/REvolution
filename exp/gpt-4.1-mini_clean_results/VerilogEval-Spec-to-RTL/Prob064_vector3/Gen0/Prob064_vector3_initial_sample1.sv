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

    // Concatenate inputs in order: a,b,c,d,e,f -> 30 bits
    wire [29:0] concat_inputs = {a, b, c, d, e, f};

    // Append two '1' bits at the LSB to make 32 bits
    wire [31:0] concat_32 = {concat_inputs, 2'b11};

    // Assign outputs by slicing the 32-bit vector
    assign w = concat_32[31:24];
    assign x = concat_32[23:16];
    assign y = concat_32[15:8];
    assign z = concat_32[7:0];

endmodule