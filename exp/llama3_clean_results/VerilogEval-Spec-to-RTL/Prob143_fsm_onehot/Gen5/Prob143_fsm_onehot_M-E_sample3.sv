module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] s0_next, s1_next, s2_next, s3_next, s4_next, s5_next, s6_next, s7_next, s8_next, s9_next;

    // Define the next states for each possible input condition
    assign s0_next = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
    assign s1_next = (in == 1'b0) ? 10'b1 : 10'b0_0000_0010;
    assign s2_next = (in == 1'b0) ? 10'b1 : 10'b0_0000_0100;
    assign s3_next = (in == 1'b0) ? 10'b1 : 10'b0_0000_1000;
    assign s4_next = (in == 1'b0) ? 10'b1 : 10'b0_0001_0000;
    assign s5_next = (in == 1'b0) ? 10'b1_0000_0000 : 10'b0_0010_0000;
    assign s6_next = (in == 1'b0) ? 10'b1_0000_0000 : 10'b0_0100_0000;
    assign s7_next = (in == 1'b0) ? 10'b1 : 10'b0_0100_0000;
    assign s8_next = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
    assign s9_next = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;

    // Calculate the next state based on the current state and input
    always @(*) begin
        next_state = 10'b0;
        if (state[0] == 1'b1) next_state = s0_next;
        else if (state[1] == 1'b1) next_state = s1_next;
        else if (state[2] == 1'b1) next_state = s2_next;
        else if (state[3] == 1'b1) next_state = s3_next;
        else if (state[4] == 1'b1) next_state = s4_next;
        else if (state[5] == 1'b1) next_state = s5_next;
        else if (state[6] == 1'b1) next_state = s6_next;
        else if (state[7] == 1'b1) next_state = s7_next;
        else if (state[8] == 1'b1) next_state = s8_next;
        else if (state[9] == 1'b1) next_state = s9_next;

        // Determine the output values based on the current state and input
        out1 = (state[7] == 1'b1 && in == 1'b1) || (state[8] == 1'b1) || (state[9] == 1'b1);
        out2 = (state[7] == 1'b1 && in == 1'b1) || (state[9] == 1'b1);
    end

endmodule