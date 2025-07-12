module TopModule(
    input clk,
    input a,
    output reg q
);

// Define states
enum logic [0:0] {STATE_HIGH, STATE_LOW} state, next_state;

// Initial state
initial state = STATE_HIGH;

// Output q based on current state
always @(*) begin
    case (state)
        STATE_HIGH: q = 1'b1;
        STATE_LOW: q = 1'b0;
    endcase
end

// State transition logic
always @(posedge clk) begin
    case (state)
        STATE_HIGH: if (a) state <= STATE_LOW; else state <= STATE_HIGH;
        STATE_LOW: if (!a) state <= STATE_HIGH; else state <= STATE_LOW;
    endcase
end

endmodule