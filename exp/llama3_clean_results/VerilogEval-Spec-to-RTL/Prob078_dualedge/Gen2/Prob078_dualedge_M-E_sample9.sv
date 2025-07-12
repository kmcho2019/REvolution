module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising;  // Output of flip-flop triggered on rising edge of phase-shifted clock
reg q_falling;  // Output of flip-flop triggered on falling edge of phase-shifted clock

// Generate 90-degree phase-shifted clocks
reg clk_shifted;
always @(posedge clk) begin
    clk_shifted <= ~clk_shifted;
end

// Flip-flop triggered on rising edge of phase-shifted clock
always @(posedge clk_shifted) begin
    q_rising <= d;
end

// Flip-flop triggered on falling edge of phase-shifted clock
always @(negedge clk_shifted) begin
    q_falling <= d;
end

// Select output based on original clock's phase
always @(clk or q_rising or q_falling) begin
    if (clk == 1'b1) begin
        q <= q_rising;
    end else begin
        q <= q_falling;
    end
end

endmodule