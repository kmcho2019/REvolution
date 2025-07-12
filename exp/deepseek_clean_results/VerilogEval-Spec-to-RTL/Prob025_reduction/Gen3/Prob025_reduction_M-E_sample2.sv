module TopModule (
    input [7:0] in,
    output parity
);
    // 256-entry LUT for all possible 8-bit patterns
    reg [255:0] parity_lut;
    
    // Initialize LUT with precomputed even parity bits
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            parity_lut[i] = ^i[7:0];  // Compute and store parity for each pattern
        end
    end
    
    // Output the precomputed parity
    assign parity = parity_lut[in];
endmodule