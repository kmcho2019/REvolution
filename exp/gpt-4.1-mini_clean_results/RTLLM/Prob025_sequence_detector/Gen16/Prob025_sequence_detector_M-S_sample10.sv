module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        S1   = 2'b01,
        S2   = 2'b10,
        S3   = 2'b11
    } state_t;

    state_t state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        sequence_detected = 1'b0;
        case (state)
            IDLE: 
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            S1: 
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1; // Stay on S1 if input=1 for overlapping sequences
            S2: 
                if (!data_in)
                    next_state = IDLE; // Sequence breaks here for 1001
                else
                    next_state = S3;
            S3: begin
                if (data_in) begin
                    next_state = S1;  // Next sequence start
                    sequence_detected = 1'b1; // Sequence 1001 detected
                end else
                    next_state = IDLE;
            end
            default:
                next_state = IDLE;
        endcase
    end

endmodule