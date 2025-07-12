module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the target sequence
enum logic [2:0] {
    IDLE = 3'b000,
    STATE_1 = 3'b001,
    STATE_11 = 3'b010,
    STATE_110 = 3'b011,
    STATE_1101 = 3'b100
} state, next_state;

// Initialize the FSM to the IDLE state
initial state = IDLE;

always @(*) begin
    case(state)
        IDLE: begin
            if(data == 1'b1) begin
                next_state = STATE_1;
            end else begin
                next_state = IDLE;
            end
        end
        STATE_1: begin
            if(data == 1'b1) begin
                next_state = STATE_11;
            end else begin
                next_state = IDLE;
            end
        end
        STATE_11: begin
            if(data == 1'b0) begin
                next_state = STATE_110;
            end else begin
                next_state = STATE_11;
            end
        end
        STATE_110: begin
            if(data == 1'b1) begin
                next_state = STATE_1101;
            end else begin
                next_state = IDLE;
            end
        end
        STATE_1101: begin
            next_state = STATE_1101;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(next_state == STATE_1101) begin
            start_shifting <= 1;
        end else if(state != STATE_1101) begin
            start_shifting <= 0;
        end
    end
end

endmodule