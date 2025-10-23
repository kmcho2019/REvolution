module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B (with counter embedded in logic)
reg [1:0] w_count; // Counter for 'w' highs in state B
reg [1:0] clock_counter; // Counter for clock cycles in state B

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        clock_counter <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    w_count <= 0;
                    clock_counter <= 1; // Start counting clock cycles
                end
                z <= 0; // 'z' is always 0 in state A
            end
            1: begin // State B
                if (w) begin
                    w_count <= w_count + 1; // Increment 'w' count if 'w' is high
                end
                clock_counter <= clock_counter + 1; // Increment clock counter
                if (clock_counter == 3) begin // End of three-clock cycle window
                    if (w_count == 2) begin
                        z <= 1; // Set 'z' to 1 if exactly two 'w' highs
                    end else begin
                        z <= 0; // Otherwise, set 'z' to 0
                    end
                    w_count <= 0; // Reset 'w' count
                    clock_counter <= 1; // Reset clock counter, ready for next window
                end else begin
                    z <= 0; // 'z' is 0 during the counting phase
                end
            end
        endcase
    end
end

endmodule