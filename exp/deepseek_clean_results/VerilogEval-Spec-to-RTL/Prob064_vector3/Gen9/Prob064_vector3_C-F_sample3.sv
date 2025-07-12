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

    // Concatenate all inputs (6*5=30 bits) and pad with two 1's (LSB)
    wire [31:0] final_output = {a, b, c, d, e, f, 2'b11};

    // Split into four 8-bit output vectors
    assign w = final_output[31:24];
    assign x = final_output[23:16];
    assign y = final_output[15:8];
    assign z = final_output[7:0];

endmodule