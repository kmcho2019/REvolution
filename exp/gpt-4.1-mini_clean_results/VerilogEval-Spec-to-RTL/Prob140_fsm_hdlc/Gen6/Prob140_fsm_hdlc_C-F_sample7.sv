module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding - 4-bit to allow separate output states
    // S0-S6: counts of consecutive ones (0 to 6)
    // SD: disc output state (after 5 consecutive ones + 0)
    // SF: flag output state (after 6 consecutive ones + 0)
    // SE: error state (7 or more consecutive ones)
    localparam 
        S0 = 4'd0,
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SD = 4'd7,
        SF = 4'd8,
        SE = 4'd9;

    reg [3:0] state, next_state;

    // Next state logic: combinational, driven by {state, in}
    always @(*) begin
        case ({state, in})
            // From S0
            {S0, 1'b0}: next_state = S0;
            {S0, 1'b1}: next_state = S1;

            // From S1
            {S1, 1'b0}: next_state = S0;
            {S1, 1'b1}: next_state = S2;

            // From S2
            {S2, 1'b0}: next_state = S0;
            {S2, 1'b1}: next_state = S3;

            // From S3
            {S3, 1'b0}: next_state = S0;
            {S3, 1'b1}: next_state = S4;

            // From S4
            {S4, 1'b0}: next_state = S0;
            {S4, 1'b1}: next_state = S5;

            // From S5
            {S5, 1'b0}: next_state = SD; // disc output state
            {S5, 1'b1}: next_state = S6;

            // From S6
            {S6, 1'b0}: next_state = SF; // flag output state
            {S6, 1'b1}: next_state = SE; // error state (7 or more ones)

            // From SD (disc output state)
            {SD, 1'b0}: next_state = S0;
            {SD, 1'b1}: next_state = S1;

            // From SF (flag output state)
            {SF, 1'b0}: next_state = S0;
            {SF, 1'b1}: next_state = S1;

            // From SE (error state)
            {SE, 1'b0}: next_state = S0;
            {SE, 1'b1}: next_state = SE;

            default: next_state = S0; // safe default
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore outputs: depend only on current state
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule