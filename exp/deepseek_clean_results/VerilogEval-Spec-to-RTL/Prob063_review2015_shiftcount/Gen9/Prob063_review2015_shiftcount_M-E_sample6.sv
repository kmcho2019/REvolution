module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// FSM states
typedef enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT
} state_t;

state_t current_state, next_state;

// Precompute all possible next values
wire [3:0] next_shift = {q[2:0], data};
wire [3:0] next_count = q - 1'b1;

// FSM state transition logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (shift_ena) next_state = SHIFT;
            else if (count_ena) next_state = COUNT;
            else next_state = IDLE;
        end
        SHIFT: next_state = shift_ena ? SHIFT : IDLE;
        COUNT: next_state = count_ena ? COUNT : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic based on current state
always @(posedge clk) begin
    case (next_state)
        SHIFT: q <= next_shift;
        COUNT: q <= next_count;
        default: q <= q; // IDLE
    endcase
    current_state <= next_state;
end

endmodule