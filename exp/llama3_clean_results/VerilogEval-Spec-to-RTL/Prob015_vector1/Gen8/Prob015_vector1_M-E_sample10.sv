module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // LUT (Lookup Table) to store the desired outputs
    // For simplicity, we directly assign the values in the module
    // In a real-world scenario, these would be stored in a memory or ROM
    wire [7:0] lut_hi [0:255]; // For upper 8 bits
    wire [7:0] lut_lo [0:255]; // For lower 8 bits

    // Initialize the LUT values
    integer i;
    initial begin
        for (i = 0; i < 256; i++) begin
            lut_hi[i] = i; // Direct assignment for simplicity
            lut_lo[i] = i; // Direct assignment for simplicity
        end
    end

    // Use the LUT to determine the outputs
    assign out_hi = lut_hi[in[15:8]]; // Use upper 8 bits of input as index
    assign out_lo = lut_lo[in[7:0]];  // Use lower 8 bits of input as index

endmodule