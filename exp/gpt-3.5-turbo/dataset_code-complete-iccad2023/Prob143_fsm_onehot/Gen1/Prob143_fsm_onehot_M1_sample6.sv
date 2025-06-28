module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

assign next_state = 
    (state & (in ^ 10'b0000000001)) ? 10'b0000000010 :
    (state & (in ^ 10'b0000000010)) ? 10'b0000000100 :
    (state & (in ^ 10'b0000000100)) ? 10'b0000001000 :
    (state & (in ^ 10'b0000001000)) ? 10'b0000010000 :
    (state & (in ^ 10'b0000010000)) ? 10'b0000100000 :
    (state & (in ^ 10'b0000100000)) ? 10'b0001000000 :
    (state & (in ^ 10'b0001000000)) ? 10'b0010000000 :
    (state & (in ^ 10'b0010000000)) ? 10'b0000000001 :
    (state & (in ^ 10'b0100000000)) ? 10'b0000000001 :
    (state & (in ^ 10'b1000000000)) ? 10'b0000000001 :
    10'b0000000000;

assign out1 = (state == 10'b1000000000) | (state == 10'b0010000000) | (state == 10'b0100000000);
assign out2 = (state == 10'b0000000001) | (state == 10'b0000000010);

endmodule