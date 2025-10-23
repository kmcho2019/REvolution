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
        q <= 1'b0;
    end else begin
        state <= STATE_HIGH;
        q <= 1'b1;
    end
end

endmodule