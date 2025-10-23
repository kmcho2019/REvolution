module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

typedef enum logic [1:0] {
    STATE_A = 2'b01,  // one-hot encoding
    STATE_B = 2'b10
} state_t;

state_t state, next_state;

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = x ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_B;
        default: next_state = STATE_A;
    endcase
end

// Output logic (Mealy)
always @(*) begin
    case (state)
        STATE_A: z = x;
        STATE_B: z = ~x;
        default: z = 1'b0;
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= STATE_A;
    else
        state <= next_state;
end

endmodule