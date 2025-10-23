module sequence_detector(
    input clk,  // Clock signal
    input reset_n,  // Reset signal (active low)
    input data_in,  // 1-bit binary input signal
    output reg sequence_detected  // 1-bit output signal indicating sequence detection
);

// Define the states of the FSM
enum logic [2:0] {IDLE, S1, S2, S3, S4} current_state, next_state;

// State machine transitions
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0) next_state = S2;
            else next_state = IDLE;
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

// Update current state on clock edge
always_ff @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule