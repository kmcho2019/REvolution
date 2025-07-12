module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Implements checkerboard Karnaugh map using XOR parity
    // Output is 1 when odd number of inputs are 1
    assign out = (a ^ b) ^ (c ^ d);  // Grouped XORs for clarity

endmodule