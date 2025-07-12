module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // active low reset
    input  wire data_in,
    output reg  sequence_detected
);

    typedef enum logic [1:0] {
        IDLE = 2'd0,   // no match yet
        S1   = 2'd1,   // matched '1'
        S2   = 2'd2,   // matched '10'
        S3   = 2'd3    // matched '100'
    } state_t;

    state_t current_state, next_state;

    // State register with asynchronous active low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state and output logic (Mealy machine)
    always @(*) begin
        // Default assignments
        next_state = IDLE;
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
                else // data_in == 1
                    next_state = S1;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = S3;
                else // data_in == 1
                    next_state = S1;
            end

            S3: begin
                if (data_in == 1'b1) begin
                    sequence_detected = 1'b1;
                    next_state = S1;
                end else // data_in == 0
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                sequence_detected = 1'b0;
            end
        endcase
    end

endmodule