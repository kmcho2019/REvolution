module sequence_detector(
    input logic clk,
    input logic reset_n,
    input logic data_in,
    output logic sequence_detected
);

// Define the states of the finite state machine
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Current state and next state
state_t current_state, next_state;

// Output logic
assign sequence_detected = (current_state == S4);

// Next state logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// State transition logic
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule