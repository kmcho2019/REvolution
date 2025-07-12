module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 00: Idle, 01: S1, 10: S2, 11: S3, 02-03 and other values not used, can be ignored or optimized
reg start_shifting_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state to Idle
        start_shifting_reg <= 1'b0; // Reset start_shifting to 0
    end else begin
        case(state)
            2'b00: begin // Idle state
                if(data == 1'b1) begin
                    state <= 2'b01; // Transition to S1 state
                end
            end
            2'b01: begin // S1 state
                if(data == 1'b1) begin
                    state <= 2'b10; // Transition to S2 state
                end else begin
                    state <= 2'b00; // Return to Idle state
                end
            end
            2'b10: begin // S2 state
                if(data == 1'b0) begin
                    state <= 2'b11; // Transition to S3 state
                end else begin
                    state <= 2'b00; // Return to Idle state
                end
            end
            2'b11: begin // S3 state
                if(data == 1'b1) begin
                    state <= 2'b02; // Transition to Found state
                    start_shifting_reg <= 1'b1; // Set start_shifting to 1
                end else begin
                    state <= 2'b00; // Return to Idle state
                end
            end
            default: begin // Found state
                // Stay in Found state, do nothing
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule