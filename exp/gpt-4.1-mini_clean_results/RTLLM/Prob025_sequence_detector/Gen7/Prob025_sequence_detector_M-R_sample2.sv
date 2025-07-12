module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding using enum for clarity
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1, // saw '1'
        S2   = 3'd2, // saw "10"
        S3   = 3'd3  // saw "100"
    } state_t;

    state_t state, next_state;

    // Next state logic and output combinational
    logic seq_detected_comb;

    always @(*) begin
        // Default assignments
        next_state = IDLE;
        seq_detected_comb = 1'b0;

        case(state)
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
                    next_state = S1;
            end
            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = IDLE;
            end
            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S1;
                    seq_detected_comb = 1'b1;  // Sequence "1001" detected at this input
                end else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output is combinational Mealy output
    assign sequence_detected = seq_detected_comb;

endmodule