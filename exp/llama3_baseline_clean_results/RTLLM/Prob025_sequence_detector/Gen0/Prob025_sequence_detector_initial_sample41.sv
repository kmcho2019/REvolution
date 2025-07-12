module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states for the FSM
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_type;

// Declare the current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Initialize sequence_detected to 0
initial sequence_detected = 0;

// FSM transition logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (data_in == 1'b0) next_state = S2;
            else next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1) next_state = S4;
            else next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update current state
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Determine sequence_detected output
always @(*) begin
    case (current_state)
        S4: sequence_detected = 1'b1;
        default: sequence_detected = 1'b0;
    endcase
end

// Initialize current state to IDLE
initial current_state = IDLE;

endmodule