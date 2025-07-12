module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // State register (A=0, B=1)
reg [2:0] w_count; // Counter for w=1 occurrences
reg [2:0] clock_cycle; // Counter for clock cycles in state B
reg z_next; // Next value of z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset state to A
        w_count <= 0; // Reset w_count
        clock_cycle <= 0; // Reset clock_cycle
        z <= 0; // Reset z
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                    w_count <= 0; // Reset w_count for new sequence
                    clock_cycle <= 1; // Start counting clock cycles
                end
            end
            1: begin // State B
                if (w) begin
                    w_count <= w_count + 1; // Increment w_count if w=1
                end
                clock_cycle <= clock_cycle + 1; // Increment clock cycle counter
                if (clock_cycle == 3) begin // End of 3 clock cycles
                    if (w_count == 2) begin // Exactly two w=1 occurrences
                        z <= 1; // Set z to 1
                    end else begin
                        z <= 0; // Otherwise, set z to 0
                    end
                    w_count <= 0; // Reset w_count for next sequence
                    clock_cycle <= 1; // Reset clock cycle counter
                end
            end
        endcase
    end
end

endmodule