module sequence_detector (
    input  wire clk,
    input  wire reset_n,            // Active-low asynchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding (one-hot for clarity and easy decoding)
    typedef enum logic [4:0] {
        IDLE = 5'b00001,
        S1   = 5'b00010,
        S2   = 5'b00100,
        S3   = 5'b01000,
        S4   = 5'b10000
    } state_t;

    state_t state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and Mealy output combinational logic
    // sequence_detected is asserted combinationally when the input completes "1001"
    logic seq_detected_comb;

    always @(*) begin
        // Default assignments
        next_state = IDLE;
        seq_detected_comb = 1'b0;

        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;   // Detected first '1'
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;   // Second bit '0'
                else
                    next_state = S1;   // Stay if another '1' (sequence restart)
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE; // sequence "100" + '0' breaks pattern
                else
                    next_state = S3;   // Third bit '0' then '1'
            end
            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S4;   // Final bit '1' matches sequence
                    seq_detected_comb = 1'b1;  // Sequence detected at input of last bit
                end else
                    next_state = S2;       // Partial overlap: "100" pattern to check next bits
            end
            S4: begin
                // After detection, allow overlapping sequences by transitioning appropriately
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
                seq_detected_comb = 1'b0;
            end
        endcase
    end

    assign sequence_detected = seq_detected_comb;

endmodule