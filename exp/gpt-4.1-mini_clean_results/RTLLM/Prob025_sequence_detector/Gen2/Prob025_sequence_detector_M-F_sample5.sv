module sequence_detector (
    input wire clk,
    input wire reset_n,     // Active-low reset as per specification
    input wire data_in,
    output reg sequence_detected
);

    typedef enum logic [2:0] {
        IDLE = 3'b000,
        S1   = 3'b001,
        S2   = 3'b010,
        S3   = 3'b011,
        S4   = 3'b100
    } state_t;

    state_t current_state, next_state;

    // Combinational next state logic
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
                    next_state = S1; // Remain on S1 if input is 1 again (start of sequence)
            end
            S2: begin
                if (data_in == 1'b0)   // Corrected condition for 3rd bit of sequence = 0
                    next_state = S3;
                else
                    next_state = IDLE;
            end
            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;
                else
                    next_state = S1; // Last 1 can start a new sequence
            end
            S4: begin
                // After detection, consider overlapping sequences
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = S2;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Output logic: assert sequence_detected when in S4 state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (current_state == S4);
    end

endmodule