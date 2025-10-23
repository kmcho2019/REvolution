module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoded states
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,  // matched '1'
        S10  = 3'b010,  // matched '10'
        S100 = 3'b011,  // matched '100'
        S1001= 3'b100   // matched '1001' (final detection)
    } state_t;

    state_t state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (!data_in)
                    next_state = S10;
                else
                    next_state = S1; // stay if input '1' to detect overlapping
            end
            S10: begin
                if (!data_in)
                    next_state = S100;
                else
                    next_state = S1; // restart sequence if input '1'
            end
            S100: begin
                if (data_in)
                    next_state = S1001; // sequence complete
                else
                    next_state = IDLE; // reset if input is 0 here
            end
            S1001: begin
                // After detection, check input for possible overlapping sequences
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted only for 1 cycle on arrival in S1001
            sequence_detected <= (next_state == S1001);
        end
    end

endmodule