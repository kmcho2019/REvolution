module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,  // matched '1'
        S10  = 3'd2,  // matched '10'
        S100 = 3'd3,  // matched '100'
        S1001= 3'd4   // matched '1001' (final detection state)
    } state_t;

    state_t state, next_state;

    // Combinational next state and output logic (Mealy style)
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        sequence_detected = 1'b0;

        case(state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (~data_in)       // data_in == 0
                    next_state = S10;
                else                // data_in == 1
                    next_state = S1;
            end

            S10: begin
                if (~data_in)       // data_in == 0
                    next_state = S100;
                else                // data_in == 1
                    next_state = S1;
            end

            S100: begin
                if (data_in) begin  // data_in == 1, sequence detected
                    next_state = S1;     // after detection, restart with '1' (overlap)
                    sequence_detected = 1'b1;
                end else begin
                    next_state = IDLE;
                end
            end

            S1001: begin
                // This state is optional here; can be used if detection is delayed one cycle
                // We won't actually use this state here since detection occurs in S100 on input '1'.
                next_state = IDLE;
                sequence_detected = 1'b0;
            end

            default: next_state = IDLE;
        endcase
    end

    // Synchronous state update and output register
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected updated combinationally above, but registered here for output stability
            // This requires another register stage; instead keep sequence_detected assigned here to follow Mealy output
            // However, here we only register it for stable output, or keep as combinational output if preferred.
            sequence_detected <= sequence_detected;
        end
    end

endmodule