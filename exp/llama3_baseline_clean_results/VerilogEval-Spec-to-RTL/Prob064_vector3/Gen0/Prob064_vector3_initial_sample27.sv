module TopModule(
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

// Concatenate input vectors
wire [29:0] inputs;
assign inputs = {a, b, c, d, e, f};

// Concatenate two 1 bits to the end of the input vector
wire [31:0] inputs_ext;
assign inputs_ext = {inputs, 2'b11};

// Split the concatenated vector into output vectors
assign w = inputs_ext[31:24];
assign x = inputs_ext[23:16];
assign y = inputs_ext[15:8];
assign z = inputs_ext[7:0];

endmodule