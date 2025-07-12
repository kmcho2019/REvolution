module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg state; // 0: Reset, 1: Normal Operation

always @(posedge clk or posedge ar) begin
    if (ar) begin
        state <= 0; // Transition to reset state
        q <= 1'b0; // Reset output
    end else if (state == 0) begin
        // Wait for clock edge in reset state
        if (posedge clk) begin
            state <= 1; // Transition to normal operation state
        end
    end else if (posedge clk) begin
        // Capture input in normal operation state
        q <= d;
    end
end

endmodule