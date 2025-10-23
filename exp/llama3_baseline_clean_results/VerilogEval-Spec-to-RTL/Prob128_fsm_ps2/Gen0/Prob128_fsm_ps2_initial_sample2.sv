module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    DONE
} state, next_state;

// Initialize the output
assign done = (state == DONE);

// FSM logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (in[3] == 1) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule