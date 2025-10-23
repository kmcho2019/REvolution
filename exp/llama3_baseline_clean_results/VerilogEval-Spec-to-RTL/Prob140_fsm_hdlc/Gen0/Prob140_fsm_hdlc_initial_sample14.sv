module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define states
enum logic [3:0] {IDLE, ONE, TWO_ONES, THREE_ONES, FOUR_ONES, FIVE_ONES, SIX_ONES, ERR} state, next_state;

// Initialize outputs
assign disc = (state == FIVE_ONES) && in == 0;
assign flag = (state == SIX_ONES) && in == 0;
assign err = state == ERR;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (state)
        IDLE: begin
            if (in) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (in) begin
                next_state = TWO_ONES;
            end else begin
                next_state = IDLE;
            end
        end
        TWO_ONES: begin
            if (in) begin
                next_state = THREE_ONES;
            end else begin
                next_state = IDLE;
            end
        end
        THREE_ONES: begin
            if (in) begin
                next_state = FOUR_ONES;
            end else begin
                next_state = IDLE;
            end
        end
        FOUR_ONES: begin
            if (in) begin
                next_state = FIVE_ONES;
            end else begin
                next_state = IDLE;
            end
        end
        FIVE_ONES: begin
            if (in) begin
                next_state = SIX_ONES;
            end else begin
                next_state = IDLE;
            end
        end
        SIX_ONES: begin
            if (in) begin
                next_state = ERR;
            end else begin
                next_state = IDLE;
            end
        end
        ERR: begin
            next_state = ERR;
        end
    endcase
end

endmodule