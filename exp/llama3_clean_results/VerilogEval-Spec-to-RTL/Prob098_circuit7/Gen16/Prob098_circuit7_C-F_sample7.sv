module TopModule(
    input clk,
    input a,
    output reg q
);

// Define states
enum logic [0:0] {STATE_HIGH, STATE_LOW} state;

// Initial state
initial state = STATE_HIGH;

// State transition logic
always @(posedge clk) 
    state <= a? STATE_LOW : STATE_HIGH;

// Output q based on current state
always @(*) 
    q = (state == STATE_HIGH)? 1'b1 : 1'b0;

endmodule