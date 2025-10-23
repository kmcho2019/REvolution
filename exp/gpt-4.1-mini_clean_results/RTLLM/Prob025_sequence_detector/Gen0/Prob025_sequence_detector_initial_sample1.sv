module sequence_detector(
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
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
                else
                    next_state = S1; // remain if input is 1 to allow overlapping sequences
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else
                    next_state = IDLE;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = IDLE;
            end

            S4: begin
                // After detection, check for overlapping sequences:
                // If input is '1', go to S1, else go to IDLE
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected is high only in S4
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S4);
    end

endmodule