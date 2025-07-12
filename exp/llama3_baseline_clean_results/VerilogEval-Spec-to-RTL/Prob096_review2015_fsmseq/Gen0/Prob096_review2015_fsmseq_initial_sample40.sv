module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [2:0] state; // 3 bits to represent 5 states (0 to 4)
reg start_shifting_reg;

always @(posedge clk) begin
    if (reset) begin // Reset is active high
        state <= 0; // Reset state to IDLE
        start_shifting_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (data) begin
                    state <= 1; // Move to SEEN_1 state if input is 1
                end else begin
                    state <= 0; // Stay in IDLE if input is 0
                end
            end
            1: begin // SEEN_1 state
                if (data) begin
                    state <= 2; // Move to SEEN_11 state if input is 1
                end else begin
                    state <= 3; // Move to SEEN_1_0 if input is 0, but since we only care about 1101, we'll treat it as SEEN_1
                    state <= 1; 
                end
            end
            2: begin // SEEN_11 state
                if (data) begin
                    state <= 2; // Move to SEEN_11 if input is 1
                end else begin
                    state <= 4; // Move to SEEN_110 state if input is 0
                end
            end
            3: begin // We treat this as SEEN_1_0 state, but actually move back to seen_1, because our target sequence is 1101
                if (data) begin
                    state <= 1; // Move to SEEN_1
                end else begin
                    state <= 1; // Stay in SEEN_1
                end
            end
            4: begin // SEEN_110 state
                if (data) begin
                    state <= 2; // If input is 1, move to SEEN_11
                end else begin
                    state <= 1; // If input is 0, move to FOUND but actually move back to SEEN_1
                    state <= 5; 
                end
            end
            5: begin // FOUND state
                start_shifting_reg <= 1;
                state <= 5; // Stay in FOUND state until reset
            end
            default: state <= 0; // In case of any unexpected state, reset to IDLE
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule