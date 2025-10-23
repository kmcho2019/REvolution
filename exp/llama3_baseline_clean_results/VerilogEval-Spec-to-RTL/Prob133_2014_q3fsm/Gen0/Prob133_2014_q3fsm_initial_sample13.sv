module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] counter; // Counter for the three clock cycles in State B
reg w_count; // Count of w = 1 in the three clock cycles
reg z_next; // Next value of output z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to State A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to State B
                    counter <= 1; // Start counter
                    w_count <= w; // Initialize w_count based on current w
                end else begin
                    state <= 0; // Stay in State A
                end
                z <= 0; // z is always 0 in State A
            end
            1: begin // State B
                if (counter < 3) begin // Within the three clock cycles
                    counter <= counter + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                end else begin // End of the three clock cycles
                    counter <= 0; // Reset counter
                    if (w_count == 2) begin // If w = 1 exactly twice
                        z_next <= 1; // Set z to 1 for the next cycle
                    end else begin
                        z_next <= 0; // Otherwise, z remains 0
                    end
                    w_count <= w; // Reset w_count for the next window
                end
                if (counter == 3) begin // After the three cycles, update z
                    z <= z_next;
                end else begin
                    z <= 0; // z is 0 during the counting
                end
            end
        endcase
    end
end

endmodule