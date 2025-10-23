module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state, next_state;

// Assign the output sequence_detected based on the current state
assign sequence_detected = (state == S4);

// FSM logic
always @(*) begin
    case (state)
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
    endcase
end

// Synchronize the FSM state with the clock signal
always @(posedge clk) begin
    if (!reset_n) state <= IDLE;
    else state <= next_state;
end

endmodule