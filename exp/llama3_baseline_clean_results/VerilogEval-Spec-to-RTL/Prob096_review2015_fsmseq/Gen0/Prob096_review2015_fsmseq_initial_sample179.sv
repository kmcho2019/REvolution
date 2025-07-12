module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3 bits to represent 4 states (S0 to S3), plus one extra state for when sequence is found

always @(posedge clk) begin
    if(reset) begin // Reset is active high and synchronous
        state <= 0; // Reset the state machine
        start_shifting <= 0;
    end else begin
        case(state)
            0: begin // S0: Initial state
                if(data == 1) begin
                    state <= 1; // Transition to S1 on receiving '1'
                end else begin
                    state <= 0; // Stay in S0 if not '1'
                end
            end
            1: begin // S1: First '1' received, expecting '1'
                if(data == 1) begin
                    state <= 2; // Transition to S2 on receiving '1'
                end else begin
                    state <= 0; // Reset to S0 if not '1'
                end
            end
            2: begin // S2: Second '1' received, expecting '0'
                if(data == 0) begin
                    state <= 3; // Transition to S3 on receiving '0'
                end else begin
                    state <= 0; // Reset to S0 if not '0'
                end
            end
            3: begin // S3: '0' received, expecting '1'
                if(data == 1) begin
                    state <= 4; // Set start_shifting to 1 and stay in this state
                    start_shifting <= 1;
                end else begin
                    state <= 0; // Reset to S0 if not '1'
                end
            end
            4: begin // S4: Sequence matched, keep start_shifting high
                start_shifting <= 1;
            end
            default: begin
                state <= 0;
                start_shifting <= 0;
            end
        endcase
    end
end

endmodule