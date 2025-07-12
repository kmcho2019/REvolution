module TopModule(
    input           clk,
    input           reset,
    input           data,
    output reg      start_shifting
);

// Define states
enum logic [1:0] {
    IDLE,
    GOT_11,
    GOT_110,
    GOT_1101
} state, next_state;

always @(*) begin
    case(state)
        IDLE: begin
            if(data) next_state = GOT_11;
            else next_state = IDLE;
        end
        GOT_11: begin
            if(data) next_state = GOT_110;
            else next_state = IDLE;
        end
        GOT_110: begin
            if(!data) next_state = GOT_1101;
            else next_state = GOT_11;
        end
        GOT_1101: begin
            // Remain in this state once reached
            next_state = GOT_1101;
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
        if(state == GOT_1101) start_shifting <= 1;
        else if(next_state == GOT_1101) start_shifting <= 1;
        else start_shifting <= 0;
    end
end

endmodule