module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // State transition LUT
    wire [9:0] next_state_s0 = 10'b1;
    wire [9:0] next_state_s1 = 10'b010;
    wire [9:0] next_state_s2 = 10'b0010;
    wire [9:0] next_state_s3 = 10'b00010;
    wire [9:0] next_state_s4 = 10'b000100;
    wire [9:0] next_state_s5 = in ? 10'b100000 : 10'b100000000;
    wire [9:0] next_state_s6 = in ? 10'b1000000 : 10'b1000000000;
    wire [9:0] next_state_s7 = in ? 10'b10000000 : 10'b1;
    wire [9:0] next_state_s8 = in ? 10'b10 : 10'b1;
    wire [9:0] next_state_s9 = in ? 10'b10 : 10'b1;

    // Output LUT
    wire out1_s7 = 1'b0;
    wire out1_s8 = 1'b1;
    wire out1_s9 = 1'b1;
    wire out2_s7 = 1'b1;
    wire out2_s8 = 1'b0;
    wire out2_s9 = 1'b1;

    // State transition logic
    assign next_state = (
        state[0] ? (in ? next_state_s1 : next_state_s0) :
        state[1] ? (in ? next_state_s2 : next_state_s0) :
        state[2] ? (in ? next_state_s3 : next_state_s0) :
        state[3] ? (in ? next_state_s4 : next_state_s0) :
        state[4] ? (in ? next_state_s5 : next_state_s0) :
        state[5] ? (in ? next_state_s6 : next_state_s8) :
        state[6] ? (in ? next_state_s7 : next_state_s9) :
        state[7] ? (in ? next_state_s7 : next_state_s0) :
        state[8] ? (in ? next_state_s1 : next_state_s0) :
        state[9] ? (in ? next_state_s1 : next_state_s0) : 10'b1
    );

    // Output logic
    assign out1 = (
        state[7] ? out1_s7 :
        state[8] ? out1_s8 :
        state[9] ? out1_s9 : 1'b0
    );

    assign out2 = (
        state[7] ? out2_s7 :
        state[8] ? out2_s8 :
        state[9] ? out2_s9 : 1'b0
    );

endmodule