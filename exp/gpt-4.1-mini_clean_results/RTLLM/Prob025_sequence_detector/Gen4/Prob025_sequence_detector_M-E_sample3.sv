module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    parameter IDLE = 3'd0,
              S1   = 3'd1,  // matched '1'
              S2   = 3'd2,  // matched '10'
              S3   = 3'd3,  // matched '100'
              S4   = 3'd4;  // matched '1001' (final detected state)

    reg [2:0] state, next_state;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic: Moore FSM transitions
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else
                    next_state = S1; // Stay in S1 if input is 1 (overlapping sequence)
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = S1; // Restart at S1 because input is 1 and sequence starts with '1'
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = IDLE; // No partial overlap with other sequence prefixes
            end

            S4: begin
                // After detection, move to S1 if input=1 or IDLE if input=0 to detect overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted only in final matched state S4
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule