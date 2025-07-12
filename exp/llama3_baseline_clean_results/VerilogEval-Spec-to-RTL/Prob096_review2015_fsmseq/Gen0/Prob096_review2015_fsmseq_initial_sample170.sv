module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Enumerate the states of the FSM
enum logic [1:0] {
    IDLE,
    SEEN_1,
    SEEN_11,
    SEEN_110,
    SEEN_1101
} state, next_state;

// Output logic for start_shifting
assign start_shifting = (state == SEEN_1101);

// Sequential logic for state transition
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always_comb begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state = SEEN_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEEN_1: begin
            if (data) begin
                next_state = SEEN_11;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_11: begin
            if (data) begin
                next_state = SEEN_110;
            end else begin
                next_state = SEEN_1;
            end
        end
        SEEN_110: begin
            if (data) begin
                next_state = SEEN_1;
            end else begin
                next_state = SEEN_1101;
            end
        end
        SEEN_1101: begin
            next_state = SEEN_1101; // Stay in this state until reset
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule