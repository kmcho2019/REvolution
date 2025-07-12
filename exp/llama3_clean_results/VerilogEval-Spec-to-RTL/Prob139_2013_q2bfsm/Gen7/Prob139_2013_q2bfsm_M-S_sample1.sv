module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_state; // 0: initial, 1: seen 1, 2: seen 10
reg y_wait; // Flag indicating we're waiting for y
reg [1:0] y_count; // Count cycles since f was set

always @ (posedge clk) begin
    if (!resetn) begin
        // Reset all signals and states
        x_state <= 0;
        y_wait <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        // Sequence detection for x
        case (x_state)
            0: if (x) x_state <= 1;
            1: if (!x) x_state <= 2;
            2: if (x) begin
                x_state <= 0; // Restart sequence detection
                f <= 1; // Set f for this cycle
                y_wait <= 1;
                y_count <= 0; // Reset y count
            end else x_state <= 1; // Stay in state 1 if x is not 1
        endcase

        // Reset f for next cycle if it was set
        if (f) f <= 0;

        // Wait for y after f has been set
        if (y_wait) begin
            if (y) begin
                g <= 1; // Set g permanently if y is seen
                y_wait <= 0; // Exit wait_y state
            end else if (y_count < 2) begin
                y_count <= y_count + 1; // Increment count
            end else begin
                g <= 0; // Set g to 0 if y not seen within 2 cycles
                y_wait <= 0; // Exit wait_y state
            end
        end
    end
end

endmodule