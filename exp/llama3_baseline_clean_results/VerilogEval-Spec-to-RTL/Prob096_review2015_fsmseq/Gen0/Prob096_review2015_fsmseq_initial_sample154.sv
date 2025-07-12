module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [1:0] state; // 00: Idle, 01: Received_1, 10: Received_11, 11: Received_110

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to Idle state
        start_shifting <= 1'b0; // Clear start_shifting
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (data) begin
                    state <= 2'b01; // Move to Received_1 state
                end else begin
                    state <= 2'b00; // Stay in Idle state
                end
            end
            2'b01: begin // Received_1 state
                if (data) begin
                    state <= 2'b10; // Move to Received_11 state
                end else begin
                    state <= 2'b00; // Move back to Idle state
                end
            end
            2'b10: begin // Received_11 state
                if (~data) begin
                    state <= 2'b11; // Move to Received_110 state
                end else begin
                    state <= 2'b01; // Move back to Received_1 state
                end
            end
            2'b11: begin // Received_110 state
                if (data) begin
                    start_shifting <= 1'b1; // Set start_shifting to 1
                end else begin
                    state <= 2'b00; // Move back to Idle state
                end
            end
        endcase
    end
end

endmodule