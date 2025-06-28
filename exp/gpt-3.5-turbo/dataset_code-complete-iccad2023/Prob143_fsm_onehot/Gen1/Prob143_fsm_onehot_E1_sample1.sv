module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

wire isS0 = (state == 10'b0000000001);
wire isS1 = (state == 10'b0000000010);
wire isS2 = (state == 10'b0000000100);
wire isS3 = (state == 10'b0000001000);
wire isS4 = (state == 10'b0000010000);
wire isS5 = (state == 10'b0000100000);
wire isS6 = (state == 10'b0001000000);
wire isS7 = (state == 10'b0010000000);
wire isS8 = (state == 10'b0100000000);
wire isS9 = (state == 10'b1000000000);

assign next_state = {
  (isS0 & !in) | (isS1 & in) ? 1'b1 : 1'b0,
  (isS0 & in) | (isS2 & in) ? 1'b1 : 1'b0,
  (isS1 & !in) | (isS3 & in) ? 1'b1 : 1'b0,
  (isS2 & !in) | (isS4 & in) ? 1'b1 : 1'b0,
  (isS3 & !in) | (isS5 & in) ? 1'b1 : 1'b0,
  (isS4 & !in) | (isS6 & in) ? 1'b1 : 1'b0,
  (isS5 & !in) | (isS8 & in) ? 1'b1 : 1'b0,
  (isS5 & in) | (isS7 & in) ? 1'b1 : 1'b0,
  (isS6 & !in) | (isS9 & in) ? 1'b1 : 1'b0,
  (isS6 & in) | (isS7 & in) ? 1'b1 : 1'b0
};

assign out1 = (state == 10'b0010000000) | (state == 10'b0100000000) | (state == 10'b1000000000);
assign out2 = (state == 10'b0000000000) | (state == 10'b0000000010) | (state == 10'b0010000000);

endmodule