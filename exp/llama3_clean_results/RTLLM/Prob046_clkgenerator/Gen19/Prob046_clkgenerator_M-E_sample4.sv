module clkgenerator #(
    parameter STAGES = 3, // Number of stages in the ring oscillator
    parameter DUTY_CYCLE = 50 // Duty cycle of the generated clock
)(
    output reg clk
);

reg [STAGES-1:0] ring; // Ring oscillator

initial begin
    ring = {STAGES{1'b0}}; // Initialize the ring oscillator
    clk = 0;
end

always @(*) begin
    // Ring oscillator logic
    for (int i = 0; i < STAGES; i++) begin
        if (i == 0) begin
            ring[i] = ~ring[STAGES-1];
        end else begin
            ring[i] = ~ring[i-1];
        end
    end
    
    // Clock generation with adjustable duty cycle
    if (ring[0] == 1'b1 && $realtime() % (2 * DUTY_CYCLE) < DUTY_CYCLE) begin
        clk = 1'b1;
    end else begin
        clk = 1'b0;
    end
end

endmodule