module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

// Alternative implementation using a combination of XOR and AND gates
// assign q = (a ^ b ^ c ^ d) == 1'b0 || (a ^ b ^ c ^ d) == 1'b1;

// Original implementation using a single XOR operation
assign q = ~(a ^ b ^ c ^ d);

endmodule