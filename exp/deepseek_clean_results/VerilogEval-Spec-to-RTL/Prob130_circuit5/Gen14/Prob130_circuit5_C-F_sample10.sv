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
assign sel_mask[0] = (c[1:0] == 2'b00);  // Select b
assign sel_mask[1] = (c[1:0] == 2'b01);  // Select e
assign sel_mask[2] = (c[1:0] == 2'b10);  // Select a
assign sel_mask[3] = (c[1:0] == 2'b11);  // Select d

// Combine selected output using bitwise operations
wire [3:0] selected_output = 
    ({4{sel_mask[0]}} & b) |
    ({4{sel_mask[1]}} & e) |
    ({4{sel_mask[2]}} & a) |
    ({4{sel_mask[3]}} & d);

// Output is selected_output unless c > 3, then output 'f'
assign q = (c > 4'b0011) ? 4'b1111 : selected_output;

endmodule