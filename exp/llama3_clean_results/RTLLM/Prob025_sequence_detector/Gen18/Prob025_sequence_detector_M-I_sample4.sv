module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Define states for the FSM
typedef enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    S4 = 3'b101
} state_t;

// Current and next state variables
state_t current_state, next_state;

// FSM logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// FSM state transitions
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
                next_state = IDLE;
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
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic
assign sequence_detected = (current_state == S4);

endmodule