module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// States for the finite-state machine
enum logic [1:0] {IDLE, ONE, ONE_ONE, ONE_ONE_ZERO, SHIFT} state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

// Combinational logic
always_comb begin
    case (state)
        IDLE: begin
            if (data == 1) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (data == 1) begin
                next_state = ONE_ONE;
            end else if (data == 0) begin
                next_state = IDLE;
            end
        end
        ONE_ONE: begin
            if (data == 0) begin
                next_state = ONE_ONE_ZERO;
            end else if (data == 1) begin
                next_state = ONE_ONE;
            end
        end
        ONE_ONE_ZERO: begin
            if (data == 1) begin
                next_state = SHIFT;
            end else if (data == 0) begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            next_state = SHIFT;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule