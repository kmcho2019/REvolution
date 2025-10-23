module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Priority encoder - finds highest priority active state
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
        state[1] ? 4'd1 :
        4'd0;  // default to S0

    // Next state logic based on priority state
    assign next_state[0] = 
        (pri_state == 4'd0 && ~in) ||  // S0 stays on 0
        (pri_state == 4'd1 && ~in) ||  // S1 -> S0 on 0
        (pri_state == 4'd2 && ~in) ||  // S2 -> S0 on 0
        (pri_state == 4'd3 && ~in) ||  // S3 -> S0 on 0
        (pri_state == 4'd4 && ~in) ||  // S4 -> S0 on 0
        (pri_state == 4'd7 && ~in) ||  // S7 -> S0 on 0
        (pri_state == 4'd8 && ~in) ||  // S8 -> S0 on 0
        (pri_state == 4'd9 && ~in);    // S9 -> S0 on 0

    assign next_state[1] = 
        ((pri_state == 4'd0 || pri_state == 4'd8 || pri_state == 4'd9) && in);
    assign next_state[2] = (pri_state == 4'd1 && in);
    assign next_state[3] = (pri_state == 4'd2 && in);
    assign next_state[4] = (pri_state == 4'd3 && in);
    assign next_state[5] = (pri_state == 4'd4 && in);
    assign next_state[6] = (pri_state == 4'd5 && in);
    assign next_state[7] = (pri_state == 4'd6 && in) || (pri_state == 4'd7 && in);
    assign next_state[8] = (pri_state == 4'd5 && ~in);
    assign next_state[9] = (pri_state == 4'd6 && ~in);

    // Output logic based on priority state
    assign out1 = (pri_state == 4'd8 || pri_state == 4'd9);
    assign out2 = (pri_state == 4'd7 || pri_state == 4'd9);

endmodule