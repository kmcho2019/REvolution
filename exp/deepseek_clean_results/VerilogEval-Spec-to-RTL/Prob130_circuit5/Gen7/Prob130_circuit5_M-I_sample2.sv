module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early check for 'f' output condition
wire output_f = |c[3:2];

// 2-to-4 decoder for selection
wire [3:0] sel_decoder;
assign sel_decoder[0] = (c[1:0] == 2'b00) & ~output_f;  // Select b
assign sel_decoder[1] = (c[1:0] == 2'b01) & ~output_f;  // Select e
assign sel_decoder[2] = (c[1:0] == 2'b10) & ~output_f;  // Select a
assign sel_decoder[3] = (c[1:0] == 2'b11) & ~output_f;  // Select d

// Multiplexer implementation
assign q = output_f ? 4'b1111 :
           sel_decoder[0] ? b :
           sel_decoder[1] ? e :
           sel_decoder[2] ? a :
           d;  // sel_decoder[3] implied

endmodule