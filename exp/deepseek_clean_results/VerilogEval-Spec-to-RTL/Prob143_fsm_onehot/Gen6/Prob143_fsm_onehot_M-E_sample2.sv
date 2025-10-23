module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to select highest priority active state
wire [3:0] pri_state;
assign pri_state = 
    state[9] ? 4'd9 :
    state[8] ? 4'd8 :
    state[7] ? 4'd7 :
    state[6] ? 4'd6 :
    state[5] ? 4'd5 :
    state[4] ? 4'd4 :
    state[3] ? 4'd3 :
    state[2] ? 4'd2 :
    state[1] ? 4'd1 : 4'd0;

// Output calculation (parallel with state logic)
assign out1 = (pri_state == 4'd8) | (pri_state == 4'd9);
assign out2 = (pri_state == 4'd7) | (pri_state == 4'd9);

// State transition logic
wire [9:0] next_state_base = {10{in}} & {
    (pri_state == 4'd9) | (pri_state == 4'd8) | (pri_state == 4'd7),  // S1
    1'b0,  // S2 (handled below)
    1'b0,  // S3
    1'b0,  // S4
    (pri_state == 4'd5),  // S6
    (pri_state == 4'd6),  // S7
    1'b0,  // S8 (handled below)
    1'b0,  // S9 (handled below)
    1'b0   // S0 (handled below)
};

wire [9:0] next_state_special = {10{~in}} & {
    (pri_state == 4'd5),  // S8
    (pri_state == 4'd6),  // S9
    8'b0  // Others
};

wire next_s0 = (~in) & (
    (pri_state == 4'd0) |
    (pri_state == 4'd1) |
    (pri_state == 4'd2) |
    (pri_state == 4'd3) |
    (pri_state == 4'd4) |
    (pri_state == 4'd7) |
    (pri_state == 4'd8) |
    (pri_state == 4'd9)
);

assign next_state = 
    (next_state_base | next_state_special) | 
    (next_s0 ? 10'b1 : 10'b0) | 
    ((pri_state == 4'd1) & in ? 10'b10 : 10'b0) |
    ((pri_state == 4'd2) & in ? 10'b100 : 10'b0) |
    ((pri_state == 4'd3) & in ? 10'b1000 : 10'b0) |
    ((pri_state == 4'd4) & in ? 10'b10000 : 10'b0);

endmodule