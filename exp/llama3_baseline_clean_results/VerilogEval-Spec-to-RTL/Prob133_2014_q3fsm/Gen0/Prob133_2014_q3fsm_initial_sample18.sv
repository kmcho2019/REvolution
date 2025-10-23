module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] counter; // Counter for 3 clock cycles
reg w_count; // Counter for w = 1

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    counter <= 1; // Start counter
                    w_count <= w; // Initialize w_count
                end else begin
                    state <= 0; // Stay in A
                end
                z <= 0; // Ensure z is 0 in state A
            end
            1: begin // State B
                if (counter < 3) begin // Counting cycles
                    counter <= counter + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                end else begin // After 3 cycles
                    counter <= 1; // Reset counter
                    if (w_count == 2) begin
                        z <= 1; // Set z = 1 if w_count = 2
                    end else begin
                        z <= 0; // Otherwise, z = 0
                    end
                    w_count <= w; // Reset w_count
                end
            end
        endcase
    end
end

endmodule