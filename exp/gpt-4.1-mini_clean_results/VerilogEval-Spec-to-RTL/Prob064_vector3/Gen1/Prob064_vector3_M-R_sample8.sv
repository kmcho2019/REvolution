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

    wire [29:0] inputs_concat;
    wire [31:0] extended_concat;

    // Concatenate inputs to form 30-bit vector
    assign inputs_concat = {a, b, c, d, e, f};

    // Append two '1' bits at LSB positions to make 32-bit vector
    assign extended_concat = {inputs_concat, 2'b11};

    // Split into four 8-bit outputs from MSB to LSB
    assign w = extended_concat[31:24];
    assign x = extended_concat[23:16];
    assign y = extended_concat[15:8];
    assign z = extended_concat[7:0];

endmodule