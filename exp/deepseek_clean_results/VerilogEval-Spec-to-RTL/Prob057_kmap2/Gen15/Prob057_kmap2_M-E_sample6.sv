module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Symmetry detection signals
wire ab_xor = a ^ b;
wire cd_xor = c ^ d;
wire ac_xor = a ^ c;
wire bd_xor = b ^ d;

// Core symmetry patterns
wire sym_pattern1 = ~ab_xor & ~cd_xor;  // Both pairs equal
wire sym_pattern2 = ab_xor & ~cd_xor;   // AB different, CD equal
wire sym_pattern3 = ~ab_xor & cd_xor;   // AB equal, CD different
wire sym_pattern4 = ab_xor & cd_xor;    // Both pairs different

// Output construction using symmetry patterns
assign out = (sym_pattern1 & ~(a & b)) |          // Symmetric case 1 with masking
             (sym_pattern2 & (a | d)) |           // Symmetric case 2 with OR condition
             (sym_pattern3 & (b | c)) |           // Symmetric case 3 with OR condition
             (sym_pattern4 & ~(ac_xor & bd_xor)); // Symmetric case 4 with cross XOR masking

endmodule