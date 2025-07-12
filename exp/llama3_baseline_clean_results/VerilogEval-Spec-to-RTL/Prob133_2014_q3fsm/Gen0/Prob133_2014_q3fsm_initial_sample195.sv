module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // States: 0 (A), 1 (B), 2 (checking), 3 (output)
reg [1:0] counter; // Counter for 3-cycle window
reg [1:0] w_count; // Count of w = 1 in the window
reg z_reg; // Register for output z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state A
        counter <= 0;
        w_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    counter <= 0;
                    w_count <= 0;
                end
            end
            1: begin // State B (counting)
                if (counter < 3) begin
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    counter <= counter + 1;
                end else begin
                    state <= 2; // Move to checking state
                end
            end
            2: begin // State B (output)
                if (w_count == 2) begin
                    z_reg <= 1; // Set z to 1 if w_count = 2
                end else begin
                    z_reg <= 0; // Otherwise, set z to 0
                end
                state <= 3; // Move to output state
            end
            3: begin // Output state
                state <= 1; // Return to counting state
                counter <= 0;
                w_count <= 0;
            end
            default: begin
                state <= 0; // Default to state A
            end
        endcase
    end
end

always @(posedge clk) begin
    z <= z_reg;
end

endmodule