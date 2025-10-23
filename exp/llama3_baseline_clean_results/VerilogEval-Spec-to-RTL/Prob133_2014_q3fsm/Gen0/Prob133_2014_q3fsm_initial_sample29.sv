module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B, 2: B_waiting
reg [1:0] w_count; // Count of w highs
reg [2:0] wait_count; // Counter for 3 clock cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state A
        w_count <= 0;
        wait_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Move to state B
                    wait_count <= 1; // Start counting cycles
                    w_count <= w; // Start counting w highs
                end else begin
                    state <= 0; // Stay in state A
                    z <= 0;
                end
            end
            1: begin // State B
                if(wait_count < 3) begin // Still waiting
                    wait_count <= wait_count + 1; // Increment cycle counter
                    if(w) begin
                        w_count <= w_count + 1; // Increment w high counter
                    end
                end else begin // End of 3 cycles
                    if(w_count == 2) begin // Exactly 2 w highs
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    wait_count <= 1; // Reset cycle counter
                    w_count <= w; // Reset w high counter
                end
                state <= 1; // Stay in state B
            end
            default: state <= 0; // Default to state A
        endcase
    end
end

endmodule