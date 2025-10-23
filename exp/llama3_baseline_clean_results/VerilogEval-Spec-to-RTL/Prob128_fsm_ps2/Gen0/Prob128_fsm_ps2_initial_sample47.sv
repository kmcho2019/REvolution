module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

typedef enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state_t;
state_t state, next_state;

always_comb begin
    case(state)
        IDLE: begin
            if(in[3]) next_state = BYTE1;
            else next_state = IDLE;
        end
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = BYTE3;
        BYTE3: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
            BYTE3: done <= 1'b1;
            default: done <= 1'b0;
        endcase
    end
end

endmodule