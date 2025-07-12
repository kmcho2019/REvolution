module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Create a 16x4 memory for the lookup table
reg [3:0] lut [0:15];

// Initialize the lookup table
always @(*) begin
    // Default case (c >= 4)
    for (integer i = 4; i < 16; i = i + 1) begin
        lut[i] = 4'b1111; // 'f' value
    end
    
    // Special cases
    lut[0] = b;
    lut[1] = e;
    lut[2] = a;
    lut[3] = d;
end

// Output is selected based on c
assign q = lut[c];

endmodule