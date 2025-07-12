module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // Current state (S0 to S5)

// State encoding: 
// 3'b000: S0 (initial state)
// 3'b001: S1
// 3'b010: S2
// 3'b011: S3
// 3'b100: S4
// 3'b101: S5 (final state)

always @(posedge CLK or posedge RST) begin
    if (RST) begin // Reset the state and output
        state <= 3'b000; // Go back to initial state
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // S0
                if (IN == 1'b1) begin // First bit of sequence matched
                    state <= 3'b001; // Move to S1
                end else begin
                    state <= 3'b000; // Stay in S0
                end
            end
            3'b001: begin // S1
                if (IN == 1'b0) begin // Second bit of sequence matched
                    state <= 3'b010; // Move to S2
                end else begin
                    state <= 3'b000; // Reset to S0
                end
            end
            3'b010: begin // S2
                if (IN == 1'b0) begin // Third bit of sequence matched
                    state <= 3'b011; // Move to S3
                end else begin
                    state <= 3'b000; // Reset to S0
                end
            end
            3'b011: begin // S3
                if (IN == 1'b1) begin // Fourth bit of sequence matched
                    state <= 3'b100; // Move to S4
                end else begin
                    state <= 3'b000; // Reset to S0
                end
            end
            3'b100: begin // S4
                if (IN == 1'b1) begin // Fifth bit of sequence matched
                    state <= 3'b101; // Move to S5
                    MATCH <= 1'b1; // Output MATCH = 1
                end else begin
                    state <= 3'b000; // Reset to S0
                end
            end
            3'b101: begin // S5
                MATCH <= 1'b0; // Output MATCH = 0 after one clock cycle
                state <= 3'b000; // Reset to S0
            end
            default: begin
                state <= 3'b000; // Invalid state, reset to S0
            end
        endcase
    end
end

endmodule