module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'd0,
        S1   = 3'd1,
        S2   = 3'd2,
        S3   = 3'd3,
        S4   = 3'd4
    } state_t;

    state_t current_state, next_state;

    // Sequential logic: state update
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Combinational logic: next state logic and output logic
    always @(*) begin
        // Default values
        next_state = current_state;
        sequence_detected = 1'b0;

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
                else
                    next_state = S1;  // '1' again can be start of sequence
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else // data_in == 1
                    next_state = S3;
            end

            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S1;  // sequence restarted after last 1
                end else begin
                    next_state = S4;
                end
            end

            S4: begin
                sequence_detected = 1'b1;
                // After detecting sequence "1001", check input to determine next state
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule