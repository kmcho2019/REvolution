module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early detection of 'f' condition
wire output_f = |c[3:2];

// 2-to-4 decoder for selection masks
wire [3:0] sel_decoder;
assign sel_decoder[0] = (c[1:0] == 2'b00);  // Select b
assign sel_decoder[1] = (c[1:0] == 2'b01);  // Select e
assign sel_decoder[2] = (c[1:0] == 2'b10);  // Select a
assign sel_decoder[3] = (c[1:0] == 2'b11);  // Select d

// Output selection using decoded masks
wire [3:0] selected_output = 
    ({4{sel_decoder[0]}} & b) |
    ({4{sel_decoder[1]}} & e) |
    ({4{sel_decoder[2]}} & a) |
    ({4{sel_decoder[3]}} & d);

// Final output selection
assign q = output_f ? 4'b1111 : selected_output;

endmodule