module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define FSM states
enum logic [1:0] {IDLE, PULSE_START, PULSE_END} state, next_state;

// Sequential logic to update state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine next state and output
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = PULSE_START;
            end else begin
                next_state = IDLE;
            end
            data_out = 1'b0;
        end
        PULSE_START: begin
            if (data_in == 1'b0) begin
                next_state = PULSE_END;
            end else begin
                next_state = PULSE_START;
            end
            data_out = 1'b0;
        end
        PULSE_END: begin
            next_state = IDLE;
            data_out = 1'b1;
        end
        default: begin
            next_state = IDLE;
            data_out = 1'b0;
        end
    endcase
end

endmodule