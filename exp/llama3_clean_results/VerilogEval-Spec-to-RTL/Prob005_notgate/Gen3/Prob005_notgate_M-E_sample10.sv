module TopModule(
    input  in,
    output out
);

reg [1:0] lut[1:0]; // Lookup table to store NOT gate outputs
integer i;

initial begin
    // Initialize the lookup table with NOT gate outputs
    lut[0] = 1; // Output for input 0 is 1
    lut[1] = 0; // Output for input 1 is 0
end

always @(*) begin
    // Use the input as an address to get the output from the lookup table
    out = lut[in];
end

endmodule