module sequence_detector (
    input  wire clk,
    input  wire rst_n,         // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoded FSM states
    typedef enum reg [2:0] {
        IDLE = 3'd0,   // Waiting for sequence start
        S1   = 3'd1,   // Matched '1'
        S2   = 3'd2,   // Matched '10'
        S3   = 3'd3,   // Matched '100'
        S4   = 3'd4    // Matched '1001' (sequence detected)
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;    // start of sequence detected
                else
                    next_state = IDLE;
            end

            S1: begin
                if (~data_in)
                    next_state = S2;    // matched "10"
                else
                    next_state = S1;    // consecutive '1's can still start sequence
            end

            S2: begin
                if (~data_in)
                    next_state = S3;    // matched "100"
                else
                    next_state = S1;    // '1' can restart sequence
            end

            S3: begin
                if (data_in)
                    next_state = S4;    // matched full sequence "1001"
                else
                    next_state = IDLE;  // mismatch - restart
            end

            S4: begin
                // Sequence detected in previous cycle;
                // handle overlapping: since last bit was '1', start at S1 or IDLE depending on input
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register and output logic with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output: asserted when FSM enters S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule