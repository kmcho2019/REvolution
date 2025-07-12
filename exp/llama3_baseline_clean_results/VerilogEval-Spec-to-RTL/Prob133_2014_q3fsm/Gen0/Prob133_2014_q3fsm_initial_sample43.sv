module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0 - State A, 1 - State B
reg [1:0] window_counter; // Counts clock cycles in state B
reg [1:0] w_counter; // Counts occurrences of w = 1
reg z_reg; // Register for z output

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // Reset to state A
        window_counter <= 0;
        w_counter <= 0;
        z_reg <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Move to state B
                    window_counter <= 1; // Start counting clock cycles
                    w_counter <= w ? 1 : 0; // Initialize w counter
                end else begin
                    state <= 0; // Stay in state A
                end
                z_reg <= 0; // z is always 0 in state A
            end
            1: begin // State B
                window_counter <= window_counter + 1; // Increment window counter
                if(w) begin
                    w_counter <= w_counter + 1; // Increment w counter if w = 1
                end
                if(window_counter == 3) begin // End of window
                    if(w_counter == 2) begin
                        z_reg <= 1; // Set z = 1 if w counter equals 2
                    end else begin
                        z_reg <= 0; // Otherwise, z = 0
                    end
                    window_counter <= 1; // Reset window counter
                    w_counter <= w ? 1 : 0; // Reset and reinitialize w counter
                end else begin
                    z_reg <= 0; // z = 0 during the window
                end
            end
            default: begin
                state <= 0; // Default to state A
                window_counter <= 0;
                w_counter <= 0;
                z_reg <= 0;
            end
        endcase
    end
end

assign z = z_reg;

endmodule