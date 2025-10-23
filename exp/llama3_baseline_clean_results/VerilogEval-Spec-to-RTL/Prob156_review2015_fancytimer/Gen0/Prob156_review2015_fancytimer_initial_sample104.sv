module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// States for the FSM
enum logic [3:0] {
    IDLE,
    SHIFT_DELAY,
    COUNTING,
    DONE
} state, next_state;

// Registers to store the delay value and the current count
logic [3:0] delay;
logic [12:0] count_reg;

// Combinational logic to determine the next state
always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if (reset) next_state = IDLE;
            else if (data == 1'b1) next_state = IDLE;
            else if (delay == 4'b1101) next_state = SHIFT_DELAY;
            else next_state = IDLE;
        end
        SHIFT_DELAY: begin
            if (reset) next_state = IDLE;
            else if (count_reg == 4'b1000) next_state = COUNTING;
            else next_state = SHIFT_DELAY;
        end
        COUNTING: begin
            if (reset) next_state = IDLE;
            else if (count_reg == (delay + 1'b1) * 13'd1000) next_state = DONE;
            else next_state = COUNTING;
        end
        DONE: begin
            if (reset) next_state = IDLE;
            else if (ack) next_state = IDLE;
            else next_state = DONE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update the state and registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0;
        count_reg <= 13'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        state <= next_state;
        case(state)
            IDLE: begin
                delay <= {delay[2:0], data};
            end
            SHIFT_DELAY: begin
                delay <= {delay[2:0], data};
                count_reg <= count_reg + 1'b1;
            end
            COUNTING: begin
                count_reg <= count_reg + 1'b1;
                if (count_reg % 13'd1000 == 13'd0) delay <= delay - 1'b1;
            end
            DONE: begin
                done <= 1'b1;
            end
            default: ;
        endcase
        counting <= (state == COUNTING) ? 1'b1 : 1'b0;
        count <= (state == COUNTING) ? delay : 4'b0;
    end
end

endmodule