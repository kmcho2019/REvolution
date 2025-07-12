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

    // Concatenate all inputs into one 30-bit vector
    wire [29:0] concatenated_inputs = {a, b, c, d, e, f};

    // Append two '1' bits at LSB positions to form a 32-bit vector
    wire [31:0] full_vector = {concatenated_inputs, 2'b11};

    // Assign outputs by slicing full_vector from LSB upwards with a different output order
    assign z = full_vector[7:0];
    assign y = full_vector[15:8];
    assign x = full_vector[23:16];
    assign w = full_vector[31:24];

endmodule