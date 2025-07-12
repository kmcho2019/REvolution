module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Create a 16-bit virtual lookup table by concatenating inputs
// Organized as: [d, a, e, b] (each 4 bits)
wire [15:0] lut = {d, a, e, b};

// Use lower 2 bits of c as selector (values 0-3)
wire [1:0] sel = c[1:0];

// Calculate shift amount (0,4,8,12) based on selector
wire [3:0] shift_amt = {sel, 2'b00}; // sel * 4

// Barrel shifter implementation to select correct 4-bit chunk
wire [15:0] shifted = lut >> shift_amt;
wire [3:0] selected = shifted[3:0];

// Default case when c > 3 (checks if any upper bits are set)
wire default_case = |c[3:2];

// Final output selection
assign q = default_case ? 4'b1111 : selected;

endmodule