module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output        done
);

// Define the states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

// FSM logic
always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
            end
        end
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = BYTE3;
        BYTE3: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case(state)
            IDLE: done <= 1'b0;
            BYTE1: done <= 1'b0;
            BYTE2: done <= 1'b0;
            BYTE3: done <= 1'b1;
        endcase
    end
end

endmodule