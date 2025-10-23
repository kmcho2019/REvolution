module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] next_state_s0, next_state_s1, next_state_s2, next_state_s3, next_state_s4, next_state_s5, next_state_s6, next_state_s7, next_state_s8, next_state_s9;
    reg out1_s0, out1_s1, out1_s2, out1_s3, out1_s4, out1_s5, out1_s6, out1_s7, out1_s8, out1_s9;
    reg out2_s0, out2_s1, out2_s2, out2_s3, out2_s4, out2_s5, out2_s6, out2_s7, out2_s8, out2_s9;

    always @(*) begin
        // Initialize next_state to zero and outputs to zero
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        // Define the lookup tables for each state
        next_state_s0 = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
        out1_s0 = 1'b0;
        out2_s0 = 1'b0;

        next_state_s1 = (in == 1'b0) ? 10'b1 : 10'b0_0000_0010;
        out1_s1 = 1'b0;
        out2_s1 = 1'b0;

        next_state_s2 = (in == 1'b0) ? 10'b1 : 10'b0_0000_0100;
        out1_s2 = 1'b0;
        out2_s2 = 1'b0;

        next_state_s3 = (in == 1'b0) ? 10'b1 : 10'b0_0000_1000;
        out1_s3 = 1'b0;
        out2_s3 = 1'b0;

        next_state_s4 = (in == 1'b0) ? 10'b1 : 10'b0_0001_0000;
        out1_s4 = 1'b0;
        out2_s4 = 1'b0;

        next_state_s5 = (in == 1'b0) ? 10'b0_0010_0000 : 10'b0_0011_0000;
        out1_s5 = 1'b0;
        out2_s5 = 1'b0;

        next_state_s6 = (in == 1'b0) ? 10'b0_0100_0000 : 10'b0_0101_0000;
        out1_s6 = 1'b0;
        out2_s6 = 1'b0;

        next_state_s7 = (in == 1'b0) ? 10'b1 : 10'b0_0101_0000;
        out1_s7 = 1'b0;
        out2_s7 = 1'b1;

        next_state_s8 = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
        out1_s8 = 1'b1;
        out2_s8 = 1'b0;

        next_state_s9 = (in == 1'b0) ? 10'b1 : 10'b0_0000_0001;
        out1_s9 = 1'b1;
        out2_s9 = 1'b1;

        // Use multiplexers to select the correct lookup table based on the current state and input
        if (state[0] == 1'b1) begin
            next_state = next_state_s0;
            out1 = out1_s0;
            out2 = out2_s0;
        end else if (state[1] == 1'b1) begin
            next_state = next_state_s1;
            out1 = out1_s1;
            out2 = out2_s1;
        end else if (state[2] == 1'b1) begin
            next_state = next_state_s2;
            out1 = out1_s2;
            out2 = out2_s2;
        end else if (state[3] == 1'b1) begin
            next_state = next_state_s3;
            out1 = out1_s3;
            out2 = out2_s3;
        end else if (state[4] == 1'b1) begin
            next_state = next_state_s4;
            out1 = out1_s4;
            out2 = out2_s4;
        end else if (state[5] == 1'b1) begin
            next_state = next_state_s5;
            out1 = out1_s5;
            out2 = out2_s5;
        end else if (state[6] == 1'b1) begin
            next_state = next_state_s6;
            out1 = out1_s6;
            out2 = out2_s6;
        end else if (state[7] == 1'b1) begin
            next_state = next_state_s7;
            out1 = out1_s7;
            out2 = out2_s7;
        end else if (state[8] == 1'b1) begin
            next_state = next_state_s8;
            out1 = out1_s8;
            out2 = out2_s8;
        end else if (state[9] == 1'b1) begin
            next_state = next_state_s9;
            out1 = out1_s9;
            out2 = out2_s9;
        end
    end

endmodule