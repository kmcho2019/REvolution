module sequence_detector (
    input  wire clk,
    input  wire reset_n,      // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using binary codes (3 bits)
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,  // matched '1'
        S2   = 3'b010,  // matched '10'
        S3   = 3'b011,  // matched '100'
        S4   = 3'b100   // matched '1001' (final state)
    } state_t;

    state_t state, next_state;

    // Synchronous state transition with active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic to detect "1001" with overlapping sequences
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for first '1' to start
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                // After '1', expect '0' for second bit of sequence
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1; // if '1', stay in S1 (handle repeated '1's)
            end
            S2: begin
                // After '10', expect '0' again for third bit
                if (!data_in)
                    next_state = S3;
                else
                    next_state = S1; // '1' at this point can be start of new sequence
            end
            S3: begin
                // After '100', expect '1' for final bit
                if (data_in)
                    next_state = S4;
                else
                    next_state = IDLE; // reset if not '1'
            end
            S4: begin
                // Sequence detected; output asserted
                // Overlapping: next state depends on input bit
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Moore output: sequence_detected asserted only in state S4
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule