module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Enum for the states of the FSM
enum logic [2:0] {IDLE, PREFIX_1, PREFIX_11, PREFIX_110, PREFIX_1101} state, next_state;

always_comb begin
    case (state)
        IDLE: begin
            if (data == 1) next_state = PREFIX_1;
            else next_state = IDLE;
        end
        PREFIX_1: begin
            if (data == 1) next_state = PREFIX_11;
            else if (data == 0) next_state = IDLE;
        end
        PREFIX_11: begin
            if (data == 0) next_state = PREFIX_110;
            else next_state = PREFIX_1;
        end
        PREFIX_110: begin
            if (data == 1) next_state = PREFIX_1101;
            else next_state = IDLE;
        end
        PREFIX_1101: begin
            next_state = PREFIX_1101; // Stay in this state once the sequence is found
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == PREFIX_1101) start_shifting <= 1;
    end
end

endmodule