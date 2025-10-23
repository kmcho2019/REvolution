module TopModule(
    input  in,
    output out
);
    // Define a lookup table for the NOT gate's truth table
    reg [1:0] lut[1:0];
    initial begin
        // Initialize the LUT with the NOT gate's truth table
        lut[0] = 1'b1; // Input 0 maps to output 1
        lut[1] = 1'b0; // Input 1 maps to output 0
    end
    
    // Use the input to index into the LUT and assign the output
    assign out = lut[in];
endmodule