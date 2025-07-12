module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for pulse detection
typedef enum logic [1:0] {
    IDLE,
    PULSE_START,
    PULSE_MIDDLE,
    PULSE_END
} state_t;

state_t current_state; // Current state of the state machine
state_t next_state; // Next state of the state machine

// Combinational logic for state transition and output generation
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_START;
                data_out = 1'b0;
            end else begin
                next_state = IDLE;
                data_out = 1'b0;
            end
        end
        PULSE_START: begin
            if (data_in) begin
                next_state = PULSE_MIDDLE;
                data_out = 1'b0;
            end else begin
                next_state = IDLE;
                data_out = 1'b0;
            end
        end
        PULSE_MIDDLE: begin
            if (data_in) begin
                next_state = PULSE_MIDDLE;
                data_out = 1'b0;
            end else begin
                next_state = PULSE_END;
                data_out = 1'b1;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
            data_out = 1'b0;
        end
        default: begin
            next_state = IDLE;
            data_out = 1'b0;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule