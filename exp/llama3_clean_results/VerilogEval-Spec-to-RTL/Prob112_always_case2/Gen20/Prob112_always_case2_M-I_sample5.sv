module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

// The current implementation is already quite optimized for its functionality.
// However, for clarity and potential ease of modification, we could break it down:
wire msb_set = in[3];
wire bit2_set = in[2] & ~msb_set;
wire bit1_set = in[1] & ~(msb_set | bit2_set);
wire bit0_set = in[0] & ~(msb_set | bit2_set | bit1_set);

assign pos = (msb_set? 2'b11 :
              bit2_set? 2'b10 :
              bit1_set? 2'b01 :
              bit0_set? 2'b00 : 2'b00);

endmodule