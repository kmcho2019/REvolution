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

    // Concatenate all 5-bit inputs (30 bits) + 2'b11 padding = 32 bits total
    wire [31:0] concat_data = {a, b, c, d, e, f, 2'b11};

    // Split into four 8-bit outputs
    assign w = concat_data[31:24];
    assign x = concat_data[23:16];
    assign y = concat_data[15:8];
    assign z = concat_data[7:0];

endmodule