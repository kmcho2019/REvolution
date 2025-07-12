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

    // Intermediate wires for better readability
    wire [29:0] input_concat;
    wire [1:0] padding = 2'b11;
    wire [31:0] full_concat;

    // Concatenate all inputs and padding
    assign input_concat = {a, b, c, d, e, f};
    assign full_concat = {input_concat, padding};

    // Split into 8-bit outputs
    assign w = full_concat[31:24];
    assign x = full_concat[23:16];
    assign y = full_concat[15:8];
    assign z = full_concat[7:0];

endmodule