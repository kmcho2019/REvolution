module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define the states
enum logic [1:0] {
    IDLE,
    PULSE_START,
    PULSE_END
} state, next_state;

// Always block for state register
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_START;
                data_out = 0;
            end else begin
                next_state = IDLE;
                data_out = 0;
            end
        end
        PULSE_START: begin
            if (~data_in) begin
                next_state = PULSE_END;
                data_out = 0;
            end else begin
                next_state = PULSE_START;
                data_out = 0;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
            data_out = 1;
        end
        default: begin
            next_state = IDLE;
            data_out = 0;
        end
    endcase
end

endmodule