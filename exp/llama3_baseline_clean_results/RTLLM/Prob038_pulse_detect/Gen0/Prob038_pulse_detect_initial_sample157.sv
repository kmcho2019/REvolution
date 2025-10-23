module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
typedef enum logic [1:0] {
    IDLE = 2'b00,
    PULSE_START = 2'b01,
    PULSE_MIDDLE = 2'b10
} state_t;

state_t state, next_state;

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        data_out <= 0;
    end else begin // Normal operation
        state <= next_state;
        if (state == PULSE_MIDDLE && data_in == 0) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

// Combinational logic for next state and output
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1) begin
                next_state = PULSE_START;
            end else begin
                next_state = IDLE;
            end
        end
        PULSE_START: begin
            if (data_in == 1) begin
                next_state = PULSE_MIDDLE;
            end else begin
                next_state = IDLE;
            end
        end
        PULSE_MIDDLE: begin
            if (data_in == 0) begin
                next_state = IDLE;
            end else begin
                next_state = PULSE_MIDDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule