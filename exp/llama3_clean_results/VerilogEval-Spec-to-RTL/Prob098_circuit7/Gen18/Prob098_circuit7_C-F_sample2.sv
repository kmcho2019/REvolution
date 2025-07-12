module TopModule(
    input clk,
    input a,
    output reg q
);

// Define states
enum logic [0:0] {STATE_HIGH, STATE_LOW} state;

// Initial state
initial state = STATE_HIGH;

// State transition logic and output q
always @(posedge clk) begin
    if (a) begin
        state <= STATE_LOW;
    end else if (state == STATE_LOW) begin
        state <= STATE_HIGH;
    end
    q <= (state == STATE_HIGH) ? 1'b1 : 1'b0;
end

endmodule