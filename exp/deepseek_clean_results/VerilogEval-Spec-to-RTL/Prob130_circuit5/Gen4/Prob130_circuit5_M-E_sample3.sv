module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire [3:0] sel_mask0 = {4{c[1:0] == 2'b00}};  // Select b when c[1:0] = 00
wire [3:0] sel_mask1 = {4{c[1:0] == 2'b01}};  // Select e when c[1:0] = 01
wire [3:0] sel_mask2 = {4{c[1:0] == 2'b10}};  // Select a when c[1:0] = 10
wire [3:0] sel_mask3 = {4{c[1:0] == 2'b11}};  // Select d when c[1:0] = 11

wire [3:0] selected_output = 
    (b & sel_mask0) | 
    (e & sel_mask1) | 
    (a & sel_mask2) | 
    (d & sel_mask3);

// Output is selected_output unless c[3:2] are not zero, then output 'f'
assign q = (|c[3:2]) ? 4'b1111 : selected_output;

endmodule