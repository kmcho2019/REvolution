module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state; // 0: idle, 1: active

always @(posedge clock) begin
    p <= a; // Set p to 1 when a is high and clock is high
    if (a) begin
        state <= 1; // Transition to active state when a is high
    end else begin
        state <= 0; // Transition to idle state when a is low
    end
end

always @(negedge clock) begin
    if (state) begin
        q <= 1; // Set q to 1 when in active state and clock is low
    end else begin
        q <= 0; // Set q to 0 when in idle state
    end
end

endmodule