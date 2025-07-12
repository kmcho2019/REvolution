module TopModule(
    input clk,
    input a,
    output reg q
);

// Define states
enum logic [0:0] {STATE_HIGH, STATE_LOW} state;

// Initial state
initial state = STATE_HIGH;

// State transition logic and output logic
always @(posedge clk) begin
    if (state == STATE_HIGH) begin
        if (a) state <= STATE_LOW;
        q <= 1'b1;
    end else begin
        if (!a) state <= STATE_HIGH;
        q <= 1'b0;
    end
end

endmodule