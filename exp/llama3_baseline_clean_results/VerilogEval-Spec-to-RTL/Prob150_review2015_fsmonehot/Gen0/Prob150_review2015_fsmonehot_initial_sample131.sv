module TopModule(
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

assign S_next      = (state == 10'b0000000001) && !d || 
                     (state == 10'b0000000010) && !d || 
                     (state == 10'b1000000000) && ack;

assign S1_next     = (state == 10'b0000000001) && d;

assign Count_next  = (state == 10'b0000010000) && done_counting || 
                     (state == 10'b0000001000);

assign Wait_next   = (state == 10'b0000100000) && !ack;

assign B3_next     = (state == 10'b0000000100);

assign done        = (state == 10'b0000100000);

assign counting    = (state == 10'b0000010000);

assign shift_ena   = (state == 10'b0000000100) || 
                     (state == 10'b0000001000) || 
                     (state == 10'b0000010000) || 
                     (state == 10'b0000100000);

endmodule