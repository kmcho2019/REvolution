module sequence_detector(
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001, // matched '1'
        S2   = 3'b010, // matched '10'
        S3   = 3'b011, // matched '100'
        S4   = 3'b100  // matched '1001'
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;
                else // input is 1
                    next_state = S1; // remain in S1 if another '1' arrives
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else // input is 1
                    next_state = S1;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else // input is 0
                    next_state = IDLE;
            end

            S4: begin
                // Sequence detected, next state depends on current input
                // To allow overlapping sequences, check input to possibly go to S1 or IDLE
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State flip-flops and output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            current_state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule