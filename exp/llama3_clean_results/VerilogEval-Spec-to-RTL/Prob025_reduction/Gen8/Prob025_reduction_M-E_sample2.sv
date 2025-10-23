module TopModule(
    input  [7:0] in,  
    output parity    
);

// Initialize a lookup table with pre-computed parity bits for all possible 8-bit inputs
reg [1:0] lut [255:0];

always @(*) begin
    // Initialize the lookup table
    for (int i = 0; i < 256; i++) begin
        lut[i] = {1'b0, ^i};
    end
    
    // Use the lookup table to compute the parity bit
    parity = lut[in];
end

endmodule