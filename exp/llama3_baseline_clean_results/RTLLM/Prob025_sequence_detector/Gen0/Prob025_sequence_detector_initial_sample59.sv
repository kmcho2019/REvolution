module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state, next_state;

// Define the sequence to be detected
parameter SEQUENCE = 4'b1001;

// FSM logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in == SEQUENCE[3])
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == SEQUENCE[2])
                next_state = S2;
            else
                next_state = IDLE;
        end
        S2: begin
            if (data_in == SEQUENCE[1])
                next_state = S3;
            else
                next_state = IDLE;
        end
        S3: begin
            if (data_in == SEQUENCE[0])
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

// Update the current state on clock edge
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n)
        state <= IDLE;
    else
        state <= next_state;
end

// Set sequence_detected high when the sequence is detected
always_comb begin
    if (state == S4)
        sequence_detected = 1'b1;
    else
        sequence_detected = 1'b0;
end

endmodule