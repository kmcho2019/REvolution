module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Enum for states
enum logic [1:0] {
    IDLE,
    PULSE_START,
    PULSE_END
} state, next_state;

// Output logic
logic data_out_reg, data_out_next;

// Combinational logic for next state and output
always_comb begin
    next_state = state;
    data_out_next = 0;

    case(state)
        IDLE: begin
            if(data_in) begin
                next_state = PULSE_START;
            end
        end
        PULSE_START: begin
            if(~data_in) begin
                next_state = PULSE_END;
            end
        end
        PULSE_END: begin
            data_out_next = 1;
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state and output registers
always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        data_out_reg <= 0;
    end else begin
        state <= next_state;
        data_out_reg <= data_out_next;
    end
end

// Continuous assignment for output
assign data_out = data_out_reg;

endmodule