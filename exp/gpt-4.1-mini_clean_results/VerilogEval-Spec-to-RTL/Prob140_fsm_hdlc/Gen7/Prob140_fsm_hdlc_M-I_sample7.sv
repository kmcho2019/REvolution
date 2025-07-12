module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding (3-bit):
    // 0-6: count of consecutive ones (0 to 6)
    // 4: SF - flag output state (after 6 ones + 0)
    // 5: SE - error output state (7 or more ones)
    // 7: SD - disc output state (after 5 ones + 0)
    localparam 
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        SF = 3'd4,
        SE = 3'd5,
        SD = 3'd7;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0, S1, S2, S3, S4: begin
                // Counting consecutive ones up to 5
                if (in)
                    next_state = state + 1'b1; // increment count
                else
                    next_state = S0;            // reset count
            end
            S5: begin
                // After 5 consecutive ones
                if (in)
                    next_state = S6;            // 6 ones
                else
                    next_state = SD;            // disc output state after 5 ones + 0
            end
            S6: begin
                // After 6 consecutive ones
                if (in)
                    next_state = SE;            // error state (7 or more ones)
                else
                    next_state = SF;            // flag output state after 6 ones + 0
            end
            SD: begin
                // Disc output state (one cycle)
                // Return to count state depending on input
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            SF: begin
                // Flag output state (one cycle)
                // Return to count state depending on input
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            SE: begin
                // Error output state: remain if input=1 (7+ ones),
                // else reset count on 0
                if (in)
                    next_state = SE;
                else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Outputs as Moore outputs
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule