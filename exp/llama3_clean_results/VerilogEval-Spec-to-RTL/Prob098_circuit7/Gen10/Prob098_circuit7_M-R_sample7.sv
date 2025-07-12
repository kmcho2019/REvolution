module TopModule(
    input clk,
    input a,
    output reg q
);

// Define states
enum logic [0:0] {STATE_HIGH, STATE_LOW} state;

// Initial state
initial state = STATE_HIGH;
initial q = 1'b1;

// State transition logic
always @(posedge clk) begin
    if (a == 1'b0) begin
        if (state == STATE_HIGH) begin
            q <= 1'b1;
            state <= STATE_HIGH;
        end else begin
            q <= 1'b0;
            state <= STATE_HIGH;
        end
    end else begin
        if (state == STATE_HIGH) begin
            q <= 1'b0;
            state <= STATE_LOW;
        end else begin
            q <= 1'b0;
            state <= STATE_LOW;
        end
    end
end

endmodule