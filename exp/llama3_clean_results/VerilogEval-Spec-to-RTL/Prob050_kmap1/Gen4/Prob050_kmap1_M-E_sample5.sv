module TopModule(
    input  [2:0] addr, // a, b, c concatenated
    output out
);

// Define the LUT based on the Karnaugh map
reg [1:0] lut[7:0];

initial begin
    // Initialize the LUT with values from the Karnaugh map
    lut[0] = 1'b0; // a=0, b=0, c=0
    lut[1] = 1'b1; // a=0, b=0, c=1
    lut[2] = 1'b1; // a=0, b=1, c=0
    lut[3] = 1'b1; // a=0, b=1, c=1
    lut[4] = 1'b1; // a=1, b=0, c=0
    lut[5] = 1'b1; // a=1, b=0, c=1
    lut[6] = 1'b1; // a=1, b=1, c=0
    lut[7] = 1'b1; // a=1, b=1, c=1
end

always @(*) begin
    // Use the concatenated inputs as an address to the LUT
    out = lut[addr];
end

endmodule