module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE,
    SEEN1,
    SEEN11,
    SEEN110,
    SEEN1101,
    FOUND
} state_t;

state_t state, next_state;

// Define the state transition logic
always_comb begin
    case (state)
        IDLE: begin
            if (data == 1'b1) next_state = SEEN1;
            else next_state = IDLE;
        end
        SEEN1: begin
            if (data == 1'b1) next_state = SEEN11;
            else next_state = IDLE;
        end
        SEEN11: begin
            if (data == 1'b0) next_state = SEEN110;
            else next_state = SEEN1;
        end
        SEEN110: begin
            if (data == 1'b1) next_state = SEEN1101;
            else next_state = IDLE;
        end
        SEEN1101: begin
            next_state = FOUND;
        end
        FOUND: begin
            next_state = FOUND;
        end
    endcase
end

// Define the sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == FOUND || next_state == FOUND) start_shifting <= 1'b1;
    end
end

endmodule