module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state; // 0 - Idle, 1 - Seen1, 2 - Seen10

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 0; // Reset to Idle state
        z <= 0; // Reset output z
    end else begin
        case (state)
            0: begin // Idle state
                if (x) begin
                    state <= 1; // Transition to Seen1 state
                    z <= 0;
                end else begin
                    state <= 0; // Stay in Idle state
                    z <= 0;
                end
            end
            1: begin // Seen1 state
                if (~x) begin
                    state <= 2; // Transition to Seen10 state
                    z <= 0;
                end else begin
                    state <= 1; // Stay in Seen1 state
                    z <= 0;
                end
            end
            2: begin // Seen10 state
                if (x) begin
                    state <= 2; // Stay in Seen10 state and assert z
                    z <= 1;
                end else begin
                    state <= 0; // Transition back to Idle state
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule