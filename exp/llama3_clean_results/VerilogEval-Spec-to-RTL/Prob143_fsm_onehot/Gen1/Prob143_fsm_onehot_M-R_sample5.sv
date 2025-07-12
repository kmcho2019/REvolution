module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to all zeros
    wire [9:0] next_state_s0, next_state_s1, next_state_s2, next_state_s3, next_state_s4, next_state_s5, next_state_s6, next_state_s7, next_state_s8, next_state_s9;
    assign next_state_s0 = (in == 1'b0)? 10'b1 : 10'b0_0000_0001;
    assign next_state_s1 = (in == 1'b0)? 10'b1 : 10'b0_0000_0010;
    assign next_state_s2 = (in == 1'b0)? 10'b1 : 10'b0_0000_0100;
    assign next_state_s3 = (in == 1'b0)? 10'b1 : 10'b0_0000_1000;
    assign next_state_s4 = (in == 1'b0)? 10'b1 : 10'b0_0001_0000;
    assign next_state_s5 = (in == 1'b0)? 10'b1_0000_0000 : 10'b0_0010_0000;
    assign next_state_s6 = (in == 1'b0)? 10'b1_0000_0000 : 10'b0_0100_0000;
    assign next_state_s7 = (in == 1'b0)? 10'b1 : 10'b0_0100_0000;
    assign next_state_s8 = (in == 1'b0)? 10'b1 : 10'b0_0000_0001;
    assign next_state_s9 = (in == 1'b0)? 10'b1 : 10'b0_0000_0001;

    // Determine next_state for all possible current state and input combinations
    assign next_state = (state[0] == 1'b1)? next_state_s0 :
                        (state[1] == 1'b1)? next_state_s1 :
                        (state[2] == 1'b1)? next_state_s2 :
                        (state[3] == 1'b1)? next_state_s3 :
                        (state[4] == 1'b1)? next_state_s4 :
                        (state[5] == 1'b1)? next_state_s5 :
                        (state[6] == 1'b1)? next_state_s6 :
                        (state[7] == 1'b1)? next_state_s7 :
                        (state[8] == 1'b1)? next_state_s8 :
                        (state[9] == 1'b1)? next_state_s9 : 10'b0;

    // Outputs are zero unless otherwise specified
    assign out1 = (state[7] == 1'b1 && in == 1'b1) || (state[8] == 1'b1) || (state[9] == 1'b1);
    assign out2 = (state[7] == 1'b1 && in == 1'b1) || (state[9] == 1'b1);

endmodule