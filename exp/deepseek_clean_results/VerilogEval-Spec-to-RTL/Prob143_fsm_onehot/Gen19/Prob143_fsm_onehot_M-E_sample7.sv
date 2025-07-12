module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to find highest active state
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

// Next state logic based on highest priority state
assign next_state = 
    (pri_state == 4'd0) ? (in ? 10'b0000000010 : 10'b0000000001) :
    (pri_state == 4'd1) ? (in ? 10'b0000000100 : 10'b0000000001) :
    (pri_state == 4'd2) ? (in ? 10'b0000001000 : 10'b0000000001) :
    (pri_state == 4'd3) ? (in ? 10'b0000010000 : 10'b0000000001) :
    (pri_state == 4'd4) ? (in ? 10'b0000100000 : 10'b0000000001) :
    (pri_state == 4'd5) ? (in ? 10'b0001000000 : 10'b0100000000) :
    (pri_state == 4'd6) ? (in ? 10'b0010000000 : 10'b1000000000) :
    (pri_state == 4'd7) ? (in ? 10'b0010000000 : 10'b0000000001) :
    (pri_state == 4'd8) ? (in ? 10'b0000000010 : 10'b0000000001) :
    (pri_state == 4'd9) ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0000000001;

// Output logic based on highest priority state
assign out1 = (pri_state == 4'd8) || (pri_state == 4'd9);
assign out2 = (pri_state == 4'd7) || (pri_state == 4'd9);

endmodule