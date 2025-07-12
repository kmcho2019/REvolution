module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states as enum
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} current_state, next_state;

// Assign next state logic
always_comb begin
    case (current_state)
        IDLE: begin
            next_state = (data_in == 1'b1) ? S1 : IDLE;
        end
        S1: begin
            next_state = (data_in == 1'b0) ? S2 : IDLE;
        end
        S2: begin
            next_state = (data_in == 1'b0) ? S3 : IDLE;
        end
        S3: begin
            next_state = (data_in == 1'b1) ? S4 : IDLE;
        end
        S4: begin
            next_state = IDLE; // After detecting the sequence, return to IDLE
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for updating the current state
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign sequence_detected = (current_state == S4);

endmodule