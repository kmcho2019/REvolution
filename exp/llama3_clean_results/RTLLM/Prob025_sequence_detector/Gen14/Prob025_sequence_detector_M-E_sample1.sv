module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] state;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= 2'b00; // IDLE state
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data_in == 1'b1) begin
                    state <= 2'b01; // Transition to S1
                end else begin
                    state <= 2'b00; // Stay in IDLE
                end
                sequence_detected <= 1'b0;
            end
            2'b01: begin // S1 state
                if (data_in == 1'b0) begin
                    state <= 2'b10; // Transition to S2
                end else begin
                    state <= 2'b00; // Reset to IDLE if 1 is received again
                end
                sequence_detected <= 1'b0;
            end
            2'b10: begin // S2 state
                if (data_in == 1'b0) begin
                    state <= 2'b10; // Stay in S2 if 0 is received
                end else begin
                    state <= 2'b11; // Transition to S3 if 1 is received
                end
                sequence_detected <= 1'b0;
            end
            2'b11: begin // S3 state
                if (data_in == 1'b1) begin
                    state <= 2'b00; // Reset to IDLE after detecting the sequence
                    sequence_detected <= 1'b1;
                end else begin
                    state <= 2'b00; // Reset to IDLE if sequence not completed
                    sequence_detected <= 1'b0;
                end
            end
        endcase
    end
end

endmodule