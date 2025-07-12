module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire force_f = |c[3:2];  // Early detection of 'f' condition

// 2-to-4 decoder for c[1:0]
wire [3:0] decoder_out;
assign decoder_out[0] = (c[1:0] == 2'b00) & ~force_f;  // Select b
assign decoder_out[1] = (c[1:0] == 2'b01) & ~force_f;  // Select e
assign decoder_out[2] = (c[1:0] == 2'b10) & ~force_f;  // Select a
assign decoder_out[3] = (c[1:0] == 2'b11) & ~force_f;  // Select d

// 4:1 multiplexer using decoder outputs as select
assign q = force_f ? 4'b1111 :
           (decoder_out[0] ? b :
           (decoder_out[1] ? e :
           (decoder_out[2] ? a : d)));

endmodule