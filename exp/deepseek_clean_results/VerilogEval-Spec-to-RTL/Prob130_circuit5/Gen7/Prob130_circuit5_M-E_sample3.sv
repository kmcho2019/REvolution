module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Concatenate all possible outputs in selection order: b, e, a, d
wire [15:0] output_lut = {d, a, e, b};

// Calculate the shift amount (4 bits per selection * c[1:0])
wire [3:0] shift_amount = {c[1:0], 2'b00};  // Multiply by 4

// Create shifted version of the LUT
wire [15:0] shifted_lut = output_lut >> shift_amount;

// Select the appropriate 4 bits (bits 3:0 of shifted version)
wire [3:0] selected_output = shifted_lut[3:0];

// Output is selected_output unless c[3:2] are not zero, then output 'f'
assign q = (|c[3:2]) ? 4'b1111 : selected_output;

endmodule