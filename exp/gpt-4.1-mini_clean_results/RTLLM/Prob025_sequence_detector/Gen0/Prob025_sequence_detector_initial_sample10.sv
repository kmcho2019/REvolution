module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // active low reset
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

// Synchronous state transition
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
                next_state = S1;  // stay in S1 if input is 1 again
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = IDLE; // does not match "100" prefix, restart
            else
                next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;  // sequence complete
            else
                next_state = S2;  // overlap detection: "1001" detected, last '0' is start of next sequence
        end
        S4: begin
            // After detection, check if next bit can be start of sequence
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Output logic: Moore machine - output based on state
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        sequence_detected <= 1'b0;
    else
        sequence_detected <= (current_state == S4);
end

endmodule