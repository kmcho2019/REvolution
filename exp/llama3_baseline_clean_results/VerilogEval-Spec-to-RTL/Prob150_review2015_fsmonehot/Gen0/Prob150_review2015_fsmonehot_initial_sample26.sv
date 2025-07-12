module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Define the one-hot encoding for each state
wire [9:0] S     = 10'b0000000001;
wire [9:0] S1    = 10'b0000000010;
wire [9:0] S11   = 10'b0000000100;
wire [9:0] S110  = 10'b0000001000;
wire [9:0] B0    = 10'b0000010000;
wire [9:0] B1    = 10'b0000100000;
wire [9:0] B2    = 10'b0001000000;
wire [9:0] B3    = 10'b0010000000;
wire [9:0] Count = 10'b0100000000;
wire [9:0] Wait  = 10'b1000000000;

// Next-state logic equations
assign B3_next = (state == B2);
assign S_next = (state == S && !d) || (state == S1 && !d) || (state == S110 && !d) || (state == Wait && ack);
assign S1_next = (state == S && d);
assign Count_next = (state == B3);
assign Wait_next = (state == Count && done_counting);

// Output logic equations
assign done = (state == Wait);
assign counting = (state == Count);
assign shift_ena = (state == B0) || (state == B1) || (state == B2) || (state == B3);

endmodule