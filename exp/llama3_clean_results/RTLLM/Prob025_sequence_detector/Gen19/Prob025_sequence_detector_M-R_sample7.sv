module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [4:0] state; // One-hot encoding for the state machine

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 5'b00001; // Reset to IDLE state
    end else begin
        case (state)
            5'b00001: // IDLE state
                if (data_in == 1'b1) begin
                    state <= 5'b00010; // Transition to S1 state
                end else begin
                    state <= 5'b00001; // Stay in IDLE state
                end
            5'b00010: // S1 state
                if (data_in == 1'b0) begin
                    state <= 5'b00100; // Transition to S2 state
                end else begin
                    state <= 5'b00001; // Reset to IDLE state
                end
            5'b00100: // S2 state
                if (data_in == 1'b0) begin
                    state <= 5'b01000; // Transition to S3 state
                end else begin
                    state <= 5'b00001; // Reset to IDLE state
                end
            5'b01000: // S3 state
                if (data_in == 1'b1) begin
                    state <= 5'b10000; // Transition to S4 state
                end else begin
                    state <= 5'b00001; // Reset to IDLE state
                end
            5'b10000: // S4 state
                sequence_detected <= 1'b1; // Set sequence_detected high
                state <= 5'b00001; // Reset to IDLE state
            default:
                state <= 5'b00001; // Reset to IDLE state
        endcase
    end
end

// Set sequence_detected low when not in S4 state
always @(posedge clk) begin
    if (state != 5'b10000) begin
        sequence_detected <= 1'b0;
    end
end

endmodule