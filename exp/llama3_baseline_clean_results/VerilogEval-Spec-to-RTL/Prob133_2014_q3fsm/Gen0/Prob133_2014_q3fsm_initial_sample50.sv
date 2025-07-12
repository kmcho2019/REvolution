module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (2'b00) and State B (2'b01)
reg [1:0] cnt; // Counter for clock cycles
reg cnt_w; // Counter for w = 1

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
        cnt <= 2'b00;
        cnt_w <= 1'b0;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01; // Transition to State B
                    cnt <= 2'b01; // Start counting clock cycles
                    cnt_w <= 1'b0; // Reset w counter
                end else begin
                    state <= 2'b00; // Stay in State A
                end
                z <= 1'b0; // z is always 0 in state A
            end
            2'b01: begin // State B
                cnt <= cnt + 1; // Increment clock cycle counter
                if (w) begin
                    cnt_w <= cnt_w + 1; // Increment w counter if w = 1
                end
                if (cnt == 2'b11) begin // After 3 clock cycles
                    state <= 2'b01; // Stay in State B
                    cnt <= 2'b01; // Reset clock cycle counter
                    z <= (cnt_w == 2) ? 1'b1 : 1'b0; // Set z based on cnt_w
                    cnt_w <= 1'b0; // Reset w counter
                end else begin
                    state <= 2'b01; // Stay in State B
                    z <= 1'b0; // z is 0 until after 3 clock cycles
                end
            end
        endcase
    end
end

endmodule