module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

wire S0_in = (state == 10'b0000000001);
wire S1_in = (state == 10'b0000000010);
wire S2_in = (state == 10'b0000000100);
wire S3_in = (state == 10'b0000001000);
wire S4_in = (state == 10'b0000010000);
wire S5_in = (state == 10'b0000100000);
wire S6_in = (state == 10'b0001000000);
wire S7_in = (state == 10'b0010000000);
wire S8_in = (state == 10'b0100000000);
wire S9_in = (state == 10'b1000000000);

assign next_state = (S0_in & !in) ? 10'b0000000001 :
                    (S0_in & in)  ? 10'b0000000010 :
                    (S1_in & !in) ? 10'b0000000001 :
                    (S1_in & in)  ? 10'b0000000100 :
                    (S2_in & !in) ? 10'b0000000001 :
                    (S2_in & in)  ? 10'b0000001000 :
                    (S3_in & !in) ? 10'b0000000001 :
                    (S3_in & in)  ? 10'b0000010000 :
                    (S4_in & !in) ? 10'b0000000001 :
                    (S4_in & in)  ? 10'b0000100000 :
                    (S5_in & !in) ? 10'b0001000000 :
                    (S5_in & in)  ? 10'b0010000000 :
                    (S6_in & !in) ? 10'b0100000000 :
                    (S6_in & in)  ? 10'b1000000000 :
                    (S7_in & !in) ? 10'b0000000001 :
                    (S7_in & in)  ? 10'b0010000000 :
                    (S8_in & !in) ? 10'b0000000001 :
                    (S8_in & in)  ? 10'b0000000010 :
                    (S9_in & !in) ? 10'b0000000001 :
                    (S9_in & in)  ? 10'b0000000010 :
                    10'b0000000000;

assign out1 = (state == 10'b0010000000) | (state == 10'b1000000000);
assign out2 = (state == 10'b0000000000) | (state == 10'b0000000001);

endmodule