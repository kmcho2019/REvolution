module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// FSM states
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_01,
    PULSE_DETECTED
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        end
        GOT_0: begin
            next_state = (data_in == 1'b1) ? GOT_01 : IDLE;
        end
        GOT_01: begin
            next_state = (data_in == 1'b0) ? PULSE_DETECTED : IDLE;
        end
        PULSE_DETECTED: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Output logic (Moore style - outputs depend only on current state)
always @(*) begin
    data_out = (current_state == PULSE_DETECTED);
end

endmodule