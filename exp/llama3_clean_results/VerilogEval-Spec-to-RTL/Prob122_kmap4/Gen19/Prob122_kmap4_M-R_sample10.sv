// Refactored module that maintains the simplicity of the XOR operation
// but explicitly defines it for clarity and adherence to coding standards.
module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out
);
    // The XOR operation is applied sequentially, which is both efficient and easy to understand.
    // This structure directly corresponds to the logic required by the Karnaugh map.
    assign out = (a ^ b) ^ (c ^ d);
endmodule