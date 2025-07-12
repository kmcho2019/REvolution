module clkgenerator #(
    parameter NUM_STAGES = 5
)(
    output reg clk
);

reg [NUM_STAGES-1:0] ring;

always @(ring) begin
    #1;
    ring[0] = ~ring[NUM_STAGES-1];
    for (int i = 1; i < NUM_STAGES; i++) begin
        ring[i] = ~ring[i-1];
    end
    clk = ring[0];
end

initial begin
    ring = 0;
    clk = 0;
end

endmodule