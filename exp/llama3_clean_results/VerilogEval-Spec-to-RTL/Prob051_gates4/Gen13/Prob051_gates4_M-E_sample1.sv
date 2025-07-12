// Define the TopModule with a lookup table implementation
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Define the lookup tables for AND, OR, and XOR operations
reg [1:0] lut_and [15:0];
reg [1:0] lut_or [15:0];
reg [1:0] lut_xor [15:0];

// Initialize the lookup tables
initial begin
    // AND gate lookup table
    lut_and[0] = 2'b0; lut_and[1] = 2'b0; lut_and[2] = 2'b0; lut_and[3] = 2'b0;
    lut_and[4] = 2'b0; lut_and[5] = 2'b0; lut_and[6] = 2'b0; lut_and[7] = 2'b0;
    lut_and[8] = 2'b0; lut_and[9] = 2'b0; lut_and[10] = 2'b0; lut_and[11] = 2'b0;
    lut_and[12] = 2'b0; lut_and[13] = 2'b0; lut_and[14] = 2'b0; lut_and[15] = 2'b1;

    // OR gate lookup table
    lut_or[0] = 2'b0; lut_or[1] = 2'b1; lut_or[2] = 2'b1; lut_or[3] = 2'b1;
    lut_or[4] = 2'b1; lut_or[5] = 2'b1; lut_or[6] = 2'b1; lut_or[7] = 2'b1;
    lut_or[8] = 2'b1; lut_or[9] = 2'b1; lut_or[10] = 2'b1; lut_or[11] = 2'b1;
    lut_or[12] = 2'b1; lut_or[13] = 2'b1; lut_or[14] = 2'b1; lut_or[15] = 2'b1;

    // XOR gate lookup table
    lut_xor[0] = 2'b0; lut_xor[1] = 2'b1; lut_xor[2] = 2'b1; lut_xor[3] = 2'b0;
    lut_xor[4] = 2'b1; lut_xor[5] = 2'b0; lut_xor[6] = 2'b0; lut_xor[7] = 2'b1;
    lut_xor[8] = 2'b1; lut_xor[9] = 2'b0; lut_xor[10] = 2'b0; lut_xor[11] = 2'b1;
    lut_xor[12] = 2'b0; lut_xor[13] = 2'b1; lut_xor[14] = 2'b1; lut_xor[15] = 2'b0;
end

// Use the lookup tables to determine the outputs
always @(*) begin
    out_and = lut_and[in];
    out_or = lut_or[in][1];
    out_xor = lut_xor[in];
end

endmodule