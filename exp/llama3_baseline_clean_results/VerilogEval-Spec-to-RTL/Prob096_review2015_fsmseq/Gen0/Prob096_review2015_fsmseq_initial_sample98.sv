module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // FSM states: Idle (3'b000), S1 (3'b001), S2 (3'b010), S3 (3'b011), S4 (3'b100)

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset state to Idle
        start_shifting <= 0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (data) begin
                    state <= 3'b001; // Move to S1 if data is 1
                end else begin
                    state <= 3'b000; // Stay in Idle if data is 0
                end
            end
            3'b001: begin // S1 state
                if (data) begin
                    state <= 3'b010; // Move to S2 if data is 1
                end else begin
                    state <= 3'b000; // Move back to Idle if data is 0
                end
            end
            3'b010: begin // S2 state
                if (data) begin
                    state <= 3'b010; // Stay in S2 if data is 1
                end else begin
                    state <= 3'b011; // Move to S3 if data is 0
                end
            end
            3'b011: begin // S3 state
                if (data) begin
                    state <= 3'b100; // Move to S4 if data is 1
                end else begin
                    state <= 3'b000; // Move back to Idle if data is 0
                end
            end
            3'b100: begin // S4 state
                start_shifting <= 1; // Set start_shifting to 1 and stay in S4
            end
            default: begin
                state <= 3'b000; // Default to Idle state
            end
        endcase
    end
end

endmodule