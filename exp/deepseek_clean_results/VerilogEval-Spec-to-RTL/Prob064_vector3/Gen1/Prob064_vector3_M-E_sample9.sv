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

    // Build the 32-bit output progressively
    wire [31:0] combined;
    assign combined[31:25] = 7'b0;  // Unused upper bits
    assign combined[24:0] = (a << 20) | (b << 15) | (c << 10) | (d << 5) | e;
    assign combined[1:0] = 2'b11;   // Force LSB bits to 1

    // Alternative way to handle the last input (f)
    wire [31:0] temp = combined | (f << 5);
    
    // Output byte extraction
    assign w = temp[31:24];
    assign x = temp[23:16];
    assign y = temp[15:8];
    assign z = temp[7:0];

endmodule