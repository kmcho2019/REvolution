module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states
enum logic [2:0] {
    IDLE = 3'b000,
    FIRST_ONE = 3'b001,
    SECOND_ONE = 3'b010,
    ZERO = 3'b011,
    LAST_ONE = 3'b100
} state, next_state;

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == LAST_ONE) begin
            start_shifting <= 1;
        end else if (state == IDLE && next_state == FIRST_ONE) begin
            start_shifting <= 0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data) begin
                next_state = FIRST_ONE;
            end else begin
                next_state = IDLE;
            end
        end
        FIRST_ONE: begin
            if (data) begin
                next_state = SECOND_ONE;
            end else begin
                next_state = IDLE;
            end
        end
        SECOND_ONE: begin
            if (~data) begin
                next_state = ZERO;
            end else begin
                next_state = IDLE;
            end
        end
        ZERO: begin
            if (data) begin
                next_state = LAST_ONE;
            end else begin
                next_state = IDLE;
            end
        end
        LAST_ONE: begin
            next_state = LAST_ONE;
        end
    endcase
end

endmodule