module TopModule (
    input [7:0] in,       // 8-bit input data
    output parity         // Even parity bit
);
    // Even parity: XOR of all bits (1 if odd number of 1s, 0 if even)
    assign parity = ^in;  // Optimal XOR reduction operation
    
    // Note: For generic width, could use:
    // parameter WIDTH = 8;
    // input [WIDTH-1:0] in;
    // But kept as 8-bit for this specific requirement
endmodule