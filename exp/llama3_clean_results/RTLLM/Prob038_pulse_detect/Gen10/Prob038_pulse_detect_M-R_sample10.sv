module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define an enumeration for the state machine
enum logic [1:0] {IDLE, HIGH, PULSE_END} state, next_state;

// Continuous assignment for output generation
assign data_out = (state == PULSE_END);

// State machine implementation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state determination
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = HIGH;
            end else begin
                next_state = IDLE;
            end
        end
        HIGH: begin
            if (~data_in) begin
                next_state = PULSE_END;
            end else begin
                next_state = HIGH;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule