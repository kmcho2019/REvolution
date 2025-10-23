module MultiConcat #(
    parameter N = 6  // Number of 5-bit inputs to concatenate
)(
    input  [5*N-1:0] in,   // Concatenated inputs: {in0, in1, ..., inN-1}
    output [5*N-1:0] out   // Output is identical concatenation
);
    // Since input is already concatenated, just pass it through
    assign out = in;
endmodule

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

    // Concatenate all inputs into a single 30-bit vector
    wire [29:0] all_inputs = {a, b, c, d, e, f};

    // Use parameterized module for potential reuse and clarity
    wire [29:0] concatenated;
    MultiConcat #(6) concat_inst(.in(all_inputs), .out(concatenated));

    // Append two '1' bits at LSB to create 32-bit combined vector
    wire [31:0] combined = {concatenated, 2'b11};

    // Split combined vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule