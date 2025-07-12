module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

// States for the FSM
enum logic [1:0] {
    IDLE,
    RECEIVE_BYTE_1,
    RECEIVE_BYTE_2,
    RECEIVE_BYTE_3
} state, nextState;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        state <= nextState;
        case(state)
            IDLE: done <= 0;
            RECEIVE_BYTE_2: done <= 0;
            RECEIVE_BYTE_3: done <= 0;
            default: done <= 0;
        endcase
        if (state == RECEIVE_BYTE_3) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

always_comb begin
    case(state)
        IDLE: begin
            if (in[3]) begin
                nextState = RECEIVE_BYTE_1;
            end else begin
                nextState = IDLE;
            end
        end
        RECEIVE_BYTE_1: begin
            nextState = RECEIVE_BYTE_2;
        end
        RECEIVE_BYTE_2: begin
            nextState = RECEIVE_BYTE_3;
        end
        RECEIVE_BYTE_3: begin
            nextState = IDLE;
        end
        default: nextState = IDLE;
    endcase
    if (reset) begin
        nextState = IDLE;
    end
end

endmodule