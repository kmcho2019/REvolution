module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // 0: initial, 1: sequence detection, 2: waiting for y
reg [1:0] count; // Count cycles

always @ (posedge clk) begin
    if (!resetn) begin
        // Reset all signals and states
        state <= 0;
        count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin
                if (x) begin
                    state <= 1;
                    count <= 1; // Start counting for sequence
                end
            end
            1: begin
                if (!x) begin
                    if (count == 1) begin
                        count <= 2; // Increment count for sequence
                    end else begin
                        state <= 0; // Reset sequence detection
                    end
                end else if (count == 2) begin
                    if (x) begin
                        state <= 2; // Transition to waiting for y
                        count <= 1; // Reset count for waiting
                        f <= 1; // Set f for this cycle
                    end else begin
                        count <= 1; // Restart sequence count
                    end
                end
            end
            2: begin
                if (y) begin
                    g <= 1; // Set g permanently if y is seen
                    state <= 0; // Return to initial state
                end else if (count < 2) begin
                    count <= count + 1; // Increment count
                end else begin
                    g <= 0; // Set g to 0 if y not seen within 2 cycles
                    state <= 0; // Return to initial state
                end
            end
        endcase

        // Reset f for next cycle if it was set
        if (f) f <= 0;
    end
end

endmodule