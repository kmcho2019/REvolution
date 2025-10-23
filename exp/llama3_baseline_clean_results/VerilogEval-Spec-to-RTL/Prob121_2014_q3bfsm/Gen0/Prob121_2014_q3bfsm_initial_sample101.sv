module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define state encoding
typedef enum logic[2:0] {
    STATE_000,
    STATE_001,
    STATE_010,
    STATE_011,
    STATE_100,
    STATE_011  // duplicate state number
} state_t;

// Internal signals
state_t current_state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= STATE_000;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for state transitions
always_comb begin
    case (current_state)
        STATE_000: next_state = x ? STATE_001 : STATE_000;
        STATE_001: next_state = x ? STATE_100 : STATE_001;
        STATE_010: next_state = x ? STATE_001 : STATE_010;
        STATE_011: next_state = x ? STATE_010 : STATE_001;
        STATE_100: next_state = x ? STATE_100 : STATE_011;
        default:  next_state = STATE_000;
    endcase
end

// Combinational logic for output z
always_comb begin
    case (current_state)
        STATE_000, STATE_001, STATE_010: z = 0;
        STATE_011, STATE_100: z = 1;
        default: z = 0;
    endcase
end

endmodule