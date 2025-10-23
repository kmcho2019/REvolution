module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Decode c[1:0] into one-hot selection
wire [3:0] sel_mask;
assign sel_mask = 4'b0001 << c[1:0];  // Efficient one-hot decoder

// Combine selected output using bitwise operations
wire [3:0] selected_output = 
    ({4{sel_mask[0]}} & b) |
    ({4{sel_mask[1]}} & e) |
    ({4{sel_mask[2]}} & a) |
    ({4{sel_mask[3]}} & d);

// Output is selected_output unless c > 3, then output 'f'
assign q = (c > 4'b0011) ? 4'b1111 : selected_output;

endmodule