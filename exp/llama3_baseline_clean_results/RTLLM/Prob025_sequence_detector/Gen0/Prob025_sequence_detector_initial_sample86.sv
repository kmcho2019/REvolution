module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    S4 = 3'b101
} state, next_state;

// Initialize the output sequence_detected
assign sequence_detected = (state == S4) ? 1'b1 : 1'b0;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        IDLE: if (data_in == 1'b1) next_state = S1;
               else next_state = IDLE;
        S1: if (data_in == 1'b0) next_state = S2;
               else next_state = IDLE;
        S2: if (data_in == 1'b0) next_state = S3;
               else next_state = IDLE;
        S3: if (data_in == 1'b1) next_state = S4;
               else next_state = IDLE;
        S4: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update the state
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule