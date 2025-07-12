module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State register (A = 0, B = 1)
reg [1:0] cnt;  // Counter for w = 1 occurrences
reg [2:0] ccnt; // Counter for clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state A
        cnt <= 0;   // Reset counter
        ccnt <= 0;  // Reset clock cycle counter
        z <= 0;     // Reset output
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    cnt <= 0;   // Reset counter
                    ccnt <= 1;  // Initialize clock cycle counter
                end else begin
                    state <= 0; // Stay in state A
                end
            end
            1: begin // State B
                ccnt <= ccnt + 1; // Increment clock cycle counter
                if (w) begin
                    cnt <= cnt + 1; // Increment counter for w = 1
                end
                if (ccnt == 3) begin
                    if (cnt == 2) begin // Check if exactly two w = 1 occurrences
                        z <= 1; // Set output z to 1
                    end else begin
                        z <= 0; // Set output z to 0
                    end
                    cnt <= 0;   // Reset counter
                    ccnt <= 1;  // Reset clock cycle counter
                end
            end
            default: begin
                state <= 0; // Default state A
            end
        endcase
    end
end

endmodule