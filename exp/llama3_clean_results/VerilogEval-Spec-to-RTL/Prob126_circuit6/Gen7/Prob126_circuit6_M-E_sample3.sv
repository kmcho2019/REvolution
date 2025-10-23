module TopModule(
    input [2:0] a,
    output [15:0] q
);

reg [15:0] lut[8]; // Lookup table with 8 entries (2^3) to cover all possibilities of a 3-bit input
integer i;

initial begin
    // Initialize the lookup table with the known output values
    lut[0] = 16'h1232;
    lut[1] = 16'haee0;
    lut[2] = 16'h27d4;
    lut[3] = 16'h5a0e;
    lut[4] = 16'h2066;
    lut[5] = 16'h64ce;
    lut[6] = 16'hc526;
    lut[7] = 16'h2f19;
end

always @(*) begin
    q = lut[a]; // Use the input 'a' as an index into the lookup table
end

endmodule