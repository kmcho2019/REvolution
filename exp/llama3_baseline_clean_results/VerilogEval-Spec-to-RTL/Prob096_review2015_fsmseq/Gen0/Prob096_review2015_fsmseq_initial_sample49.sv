module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define the states
typedef enum logic [2:0] {
    Idle,
    Got1,
    Got11,
    Got110,
    Got1101
} state_t;

state_t state, next_state;

always @(*) begin
    case(state)
        Idle: begin
            if (data == 1) next_state = Got1;
            else next_state = Idle;
        end
        Got1: begin
            if (data == 1) next_state = Got11;
            else if (data == 0) next_state = Idle;
            else next_state = Got1;
        end
        Got11: begin
            if (data == 0) next_state = Got110;
            else if (data == 1) next_state = Got11;
            else next_state = Got11;
        end
        Got110: begin
            if (data == 1) next_state = Got1101;
            else if (data == 0) next_state = Idle;
            else next_state = Got110;
        end
        Got1101: begin
            next_state = Got1101;
        end
        default: begin
            next_state = Idle;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end
    else begin
        state <= next_state;
        if (state == Got1101) start_shifting <= 1;
    end
end

endmodule