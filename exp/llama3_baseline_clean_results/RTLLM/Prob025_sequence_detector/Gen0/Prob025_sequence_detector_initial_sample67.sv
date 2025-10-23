module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define states for the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} current_state, next_state;

// Assign sequence_detected to 0 by default
assign sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;

// FSM logic
always_comb begin
    case(current_state)
        IDLE: begin
            if(data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if(data_in == 1'b0) next_state = S2;
            else if(data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S2: begin
            if(data_in == 1'b0) next_state = S3;
            else next_state = IDLE;
        end
        S3: begin
            if(data_in == 1'b1) next_state = S4;
            else next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update state on each clock cycle
always_ff @(posedge clk, negedge reset_n) begin
    if(~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule