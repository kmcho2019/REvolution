module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // Active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoded FSM states
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // Received '1'
        S2   = 3'd2, // Received "10"
        S3   = 3'd3, // Received "100"
        S4   = 3'd4  // Received "1001" (final detected)
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Output asserted only one cycle when entering S4
            sequence_detected <= (next_state == S4);
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;  // Default hold current state

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
                    next_state = S1; // Remain in S1 for overlapping '1's
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = IDLE;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4; // Sequence complete
                else
                    next_state = IDLE;
            end

            S4: begin
                // After detection, handle overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule