module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable (A = 2'b00, B = 2'b01)
reg [1:0] cnt;   // Counter to track the number of clock cycles
reg w_count;     // Counter to track the number of times w = 1
reg prev_w;      // Previous value of w

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state
        cnt <= 2'b00;
        w_count <= 1'b0;
        prev_w <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Move to state B
                    cnt <= 2'b01;   // Reset counter
                    w_count <= w;   // Reset w_count
                    prev_w <= w;    // Reset prev_w
                end else begin
                    state <= 2'b00; // Stay in state A
                end
            end
            2'b01: begin // State B
                cnt <= cnt + 1'b1;  // Increment counter
                if (w) begin
                    w_count <= w_count + 1'b1; // Increment w_count if w = 1
                end
                if (cnt == 2'b11) begin // Check w_count after 3 clock cycles
                    if (w_count == 2'b10) begin
                        z <= 1'b1; // Set z to 1 if w = 1 exactly twice
                    end else begin
                        z <= 1'b0; // Set z to 0 otherwise
                    end
                    state <= 2'b01; // Stay in state B
                    cnt <= 2'b01;   // Reset counter
                    w_count <= w;   // Reset w_count
                    prev_w <= w;    // Reset prev_w
                end else begin
                    z <= 1'b0; // Set z to 0 during the 3 clock cycles
                    state <= 2'b01; // Stay in state B
                end
            end
        endcase
    end
end

endmodule