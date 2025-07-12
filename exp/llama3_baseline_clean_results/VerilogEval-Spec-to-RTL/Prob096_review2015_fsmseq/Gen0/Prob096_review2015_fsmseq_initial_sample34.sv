module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // Idle, Sequence, Shifting

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        start_shifting <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data == 1) begin
                    state <= 1; // Start of sequence detected
                end
            end
            1: begin // First 1 detected
                if (data == 1) begin
                    state <= 2; // Second 1 detected
                end else if (data == 0) begin
                    state <= 0; // Sequence not matched, back to idle
                end
            end
            2: begin // Second 1 detected
                if (data == 0) begin
                    state <= 3; // 0 detected after two 1s
                end else begin
                    state <= 1; // Another 1, back to second 1 state
                end
            end
            3: begin // 0 detected after two 1s
                if (data == 1) begin
                    state <= 4; // Final 1 detected, sequence complete
                end else begin
                    state <= 0; // Sequence not matched, back to idle
                end
            end
            4: begin // Shifting state, do nothing
                // Once in shifting state, stay there until reset
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 0;
    end else if (state == 4) begin
        start_shifting <= 1;
    end
end

endmodule