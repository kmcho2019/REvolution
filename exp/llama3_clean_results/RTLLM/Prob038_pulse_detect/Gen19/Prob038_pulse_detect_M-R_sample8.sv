module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Enumerated type for states
enum logic [1:0] {IDLE, PULSE_START, PULSE_END} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        // Output generation based on the state
        case (state)
            IDLE: data_out <= 1'b0;
            PULSE_START: data_out <= 1'b0;
            PULSE_END: data_out <= 1'b1;
            default: data_out <= 1'b0;
        endcase
    end
end

always @(*) begin
    // State transition logic
    case (state)
        IDLE: begin
            if (data_in == 1'b1) next_state = PULSE_START;
            else next_state = IDLE;
        end
        PULSE_START: begin
            if (data_in == 1'b0) next_state = PULSE_END;
            else next_state = PULSE_START;
        end
        PULSE_END: begin
            if (data_in == 1'b0) next_state = IDLE;
            else next_state = PULSE_END;
        end
        default: next_state = IDLE;
    endcase
end

endmodule