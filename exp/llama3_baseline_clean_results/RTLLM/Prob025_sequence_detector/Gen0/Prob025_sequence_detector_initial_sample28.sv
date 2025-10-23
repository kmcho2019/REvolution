module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

// Declare the current and next states
state_t current_state, next_state;

// Combinational logic to determine the next state
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
                next_state = S2;
            end else begin
                next_state = S3;
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

// Sequential logic to update the current state
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic to assert sequence_detected when the sequence is detected
always_comb begin
    if (current_state == S4) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule