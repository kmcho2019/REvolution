module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Enum for the states of the FSM
enum logic [1:0] {IDLE, RISING, FALLING} state, next_state;

// Combinational logic for the next state
always_comb begin
    case (state)
        IDLE: begin
            if (data_in) next_state = RISING;
            else next_state = IDLE;
        end
        RISING: begin
            if (~data_in) next_state = FALLING;
            else next_state = RISING;
        end
        FALLING: begin
            if (data_in) next_state = IDLE;
            else next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for the current state and output
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (next_state)
            IDLE: data_out <= 0;
            RISING: data_out <= 0;
            FALLING: data_out <= ~data_in;
            default: data_out <= 0;
        endcase
    end
end

endmodule