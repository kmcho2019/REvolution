module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 2 states: A (2'b00), B (2'b01)
reg [1:0] counter; // Counter for clock cycles since entering state B
reg w_count; // Counter for the number of times w equals 1
reg next_z; // Temporary variable to hold the value of z for the next clock cycle

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        counter <= 2'b00;
        w_count <= 1'b0;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Move to state B
                    counter <= 2'b01; // Initialize counter
                    w_count <= w; // Initialize w_count
                end else begin
                    state <= 2'b00; // Stay in state A
                end
                z <= 1'b0;
            end
            2'b01: begin // State B
                if (counter == 2'b11) begin // Finished examining three clock cycles
                    next_z <= (w_count == 2'b10); // Set next_z based on w_count
                    w_count <= w; // Reset w_count
                    counter <= 2'b01; // Reset counter
                end else begin
                    next_z <= 1'b0; // Default next_z
                    if (w) begin
                        w_count <= w_count + 1'b1; // Increment w_count if w is 1
                    end
                    counter <= counter + 1'b1; // Increment counter
                end
                state <= 2'b01; // Stay in state B
                z <= next_z; // Update z
            end
            default: begin
                state <= 2'b00;
                counter <= 2'b00;
                w_count <= 1'b0;
                z <= 1'b0;
            end
        endcase
    end
end

endmodule