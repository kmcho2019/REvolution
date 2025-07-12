module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg detector;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 1'b0; // Reset detector
        z <= 1'b0; // Reset output
    end else begin
        // Simplified logic for output computation
        // Invert input if detector is high, otherwise pass input through
        z <= (detector)? ~x : x;
        
        // Update detector: Set high if input is '1' or detector is already high
        detector <= (detector) || x;
    end
end

endmodule