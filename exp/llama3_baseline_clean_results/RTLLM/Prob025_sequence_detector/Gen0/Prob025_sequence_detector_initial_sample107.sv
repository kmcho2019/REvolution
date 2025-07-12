module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states
enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} current_state, next_state;

// Assign the output based on the current state
assign sequence_detected = (current_state == S4);

// State machine logic
always_comb begin
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
                next_state = S1;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Synchronous reset
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule