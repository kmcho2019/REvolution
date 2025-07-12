module TopModule(
    input           clk,
    input           reset,
    input  [7:0]    in,
    output reg      done // Explicitly declare 'done' as a reg
);

typedef enum {IDLE, BYTE1, BYTE2, DONE} state_t;
state_t state, nextState;

always @(*) begin
    case(state)
        IDLE: 
            if (in[3] == 1'b1) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
        BYTE1: 
            nextState = BYTE2;
        BYTE2: 
            nextState = DONE;
        DONE: 
            nextState = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
    // Directly assign 'done' based on the state
    done <= (state == DONE);
end

endmodule