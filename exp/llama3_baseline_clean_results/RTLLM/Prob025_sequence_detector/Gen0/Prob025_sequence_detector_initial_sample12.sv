module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state;

// Initialize the current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Assign the output sequence_detected
always @(*) begin
    case (current_state)
        S4: sequence_detected = 1'b1;
        default: sequence_detected = 1'b0;
    endcase
end

// Define the state transitions
always @(*) begin
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
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
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

// Update the current state on the positive edge of the clock
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule