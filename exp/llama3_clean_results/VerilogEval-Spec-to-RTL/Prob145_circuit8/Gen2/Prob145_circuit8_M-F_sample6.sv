module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state; // 0: idle, 1: set

always @(posedge clock) begin
    if (a == 1'b1) begin
        state <= 1'b1; // Transition to set state when a is high
        p <= 1'b1; // Set p to 1
    end else begin
        state <= state; // Stay in current state if a is low
        p <= p; // Keep p unchanged
    end
end

always @(negedge clock) begin
    if (a == 1'b1) begin
        state <= 1'b0; // Reset to idle state when a is high during low clock phase
        p <= 1'b0; // Reset p to 0
        q <= 1'b0; // Reset q to 0
    end
end

always @(*) begin
    if (state == 1'b1) begin
        q = 1'b1; // Set q to 1 when in set state
    end else begin
        q = 1'b0; // Reset q to 0 when in idle state
    end
end

endmodule