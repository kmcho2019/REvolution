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

// State transition logic using inversion operation
always @(posedge clk) begin
    state <= (a) ? STATE_LOW : STATE_HIGH;
end

endmodule