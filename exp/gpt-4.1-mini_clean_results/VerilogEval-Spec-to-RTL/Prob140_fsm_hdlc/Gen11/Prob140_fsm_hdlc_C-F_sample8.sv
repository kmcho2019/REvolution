module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding
    localparam 
        S0 = 4'd0, // no ones counted
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SD = 4'd7, // disc output state (after 5 ones + 0)
        SF = 4'd8, // flag output state (after 6 ones + 0)
        SE = 4'd9; // error state (7 or more ones)

    reg [3:0] state, next_state;

    // Next state logic using concatenated {state, in}
    always @(*) begin
        case ({state, in})
            // Counting states S0 to S5
            {S0,1'b0}: next_state = S0;
            {S0,1'b1}: next_state = S1;

            {S1,1'b0}: next_state = S0;
            {S1,1'b1}: next_state = S2;

            {S2,1'b0}: next_state = S0;
            {S2,1'b1}: next_state = S3;

            {S3,1'b0}: next_state = S0;
            {S3,1'b1}: next_state = S4;

            {S4,1'b0}: next_state = S0;
            {S4,1'b1}: next_state = S5;

            {S5,1'b0}: next_state = SD; // disc output state
            {S5,1'b1}: next_state = S6;

            {S6,1'b0}: next_state = SF; // flag output state
            {S6,1'b1}: next_state = SE; // error state

            // Output states go back to normal counting after outputting
            {SD,1'b0}: next_state = S0;
            {SD,1'b1}: next_state = S1;

            {SF,1'b0}: next_state = S0;
            {SF,1'b1}: next_state = S1;

            // Error state stays until reset or 0 input (resets count)
            {SE,1'b0}: next_state = S0;
            {SE,1'b1}: next_state = SE;

            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore outputs depend only on current state
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule