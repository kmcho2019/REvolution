module sequence_detector(
    input clk, 
    input reset_n, 
    input data_in, 
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Declare the current and next state
state_t current_state, next_state;

// Initialize the current state to IDLE
initial current_state = IDLE;

// Set sequence_detected to 0 initially
initial sequence_detected = 0;

// Sequential logic to update the current state
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine the next state
always @* begin
    case (current_state)
        IDLE: begin
            if (data_in == 1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Set sequence_detected high when the sequence is detected
always @* begin
    if (current_state == S4) begin
        sequence_detected = 1;
    end else begin
        sequence_detected = 0;
    end
end

endmodule