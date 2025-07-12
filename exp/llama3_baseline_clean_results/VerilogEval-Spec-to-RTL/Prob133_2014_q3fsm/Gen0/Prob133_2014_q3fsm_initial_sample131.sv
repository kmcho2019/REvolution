module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register (0 - A, 1 - B)
reg [1:0] counter; // Counter for the 3-cycle window
reg w_count; // Flag to count w = 1 occurrences

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B on s = 1
                    counter <= 1; // Initialize counter for 3-cycle window
                    w_count <= w; // Initialize w_count
                end
            end
            1: begin // State B
                if (counter == 3) begin // End of 3-cycle window
                    if (w_count == 2) begin // If w = 1 exactly twice
                        z <= 1; // Set z = 1
                    end else begin
                        z <= 0; // Otherwise, z = 0
                    end
                    counter <= 1; // Reset counter for next 3-cycle window
                    w_count <= w; // Reset w_count
                end else begin
                    counter <= counter + 1; // Increment counter
                    if (w) begin
                        w_count <= w_count + 1; // Increment w_count if w = 1
                    end
                end
            end
        endcase
    end
end

endmodule