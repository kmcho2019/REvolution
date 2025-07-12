module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enum for states
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// Default value for output
initial sequence_detected = 1'b0;

// FSM state register
always @ (posedge clk or negedge reset_n) begin
    if (!reset_n)
        state <= IDLE;
    else
        state <= next_state;
end

// FSM combinational logic
always @ (*) begin
    next_state = state;
    sequence_detected = 1'b0;
    case (state)
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
                next_state = IDLE;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S3;
            else
                next_state = IDLE;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            sequence_detected = 1'b1;
            next_state = IDLE;
        end
    endcase
end

endmodule