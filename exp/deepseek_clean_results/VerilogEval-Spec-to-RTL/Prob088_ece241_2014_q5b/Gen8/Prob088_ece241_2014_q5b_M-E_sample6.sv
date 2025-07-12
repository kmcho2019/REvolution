module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg phase;  // 0=state A, 1=state B
    reg state;  // Tracks last input in state B

    // State transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            phase <= 1'b0;
            state <= 1'b0;
        end
        else begin
            if (!phase) begin
                // In state A - phase flips on x=1
                phase <= x;
                state <= x;
            end
            else begin
                // In state B - track x but phase stays 1
                state <= x;
            end
        end
    end

    // Output is simply phase XOR x
    assign z = phase ^ x;

endmodule