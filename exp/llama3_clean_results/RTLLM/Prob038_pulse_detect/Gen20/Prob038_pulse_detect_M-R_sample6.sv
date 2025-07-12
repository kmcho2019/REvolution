module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states for the FSM
enum logic [1:0] {IDLE, PULSE_STARTED, PULSE_END} state, next_state;

// Continuous assignment for output based on state
assign data_out = (state == PULSE_END);

// FSM logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_STARTED;
            end else begin
                next_state = IDLE;
            end
        end
        PULSE_STARTED: begin
            if (~data_in) begin
                next_state = PULSE_END;
            end else begin
                next_state = PULSE_STARTED;
            end
        end
        PULSE_END: begin
            if (~data_in) begin
                next_state = IDLE;
            end else begin
                next_state = PULSE_END;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule