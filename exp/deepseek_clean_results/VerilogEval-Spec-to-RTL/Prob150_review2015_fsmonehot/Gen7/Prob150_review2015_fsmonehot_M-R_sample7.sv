module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // One-hot encoded state
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

// Named state encoding for clarity
localparam S     = 10'b0000000001;
localparam S1    = 10'b0000000010;
localparam S11   = 10'b0000000100;
localparam S110  = 10'b0000001000;
localparam B0    = 10'b0000010000;
localparam B1    = 10'b0000100000;
localparam B2    = 10'b0001000000;
localparam B3    = 10'b0010000000;
localparam Count = 10'b0100000000;
localparam Wait  = 10'b1000000000;

// Intermediate signals for complex conditions
wire S_to_S1    = (state == S) && d;
wire S_to_S     = (state == S) && ~d;
wire S1_to_S    = (state == S1) && ~d;
wire S1_to_S11  = (state == S1) && d;
wire S11_to_S110= (state == S11) && ~d;
wire S110_to_S  = (state == S110) && ~d;
wire S110_to_B0 = (state == S110) && d;
wire Wait_to_S  = (state == Wait) && ack;
wire Wait_to_Wait = (state == Wait) && ~ack;
wire Count_to_Wait = (state == Count) && done_counting;
wire Count_to_Count = (state == Count) && ~done_counting;

// Next state logic
assign S_next = S_to_S | S1_to_S | S110_to_S | Wait_to_S;
assign S1_next = S_to_S1;
assign B3_next = (state == B2);
assign Count_next = (state == B3) | Count_to_Count;
assign Wait_next = Count_to_Wait | Wait_to_Wait;

// Output logic
assign shift_ena = (state == B0) | (state == B1) | (state == B2) | (state == B3);
assign counting = (state == Count);
assign done = (state == Wait);

endmodule