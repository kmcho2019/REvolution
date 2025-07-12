module TopModule(
    input [2:0] a,
    output [15:0] q
);

// Define an array to store the output values
reg [15:0] lut[7:0];

// Initialize the array with the output values
initial begin
    lut[0] = 16'h1232;
    lut[1] = 16'haee0;
    lut[2] = 16'h27d4;
    lut[3] = 16'h5a0e;
    lut[4] = 16'h2066;
    lut[5] = 16'h64ce;
    lut[6] = 16'hc526;
    lut[7] = 16'h2f19;
end

// Use the input to index into the array and assign the output
always @(*) begin
    q = lut[a];
end

endmodule