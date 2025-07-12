module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] current_state;

// Initialize the current state to IDLE (00)
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= 2'b00;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            2'b00: begin // IDLE
                if (data_in == 1'b1) begin
                    current_state <= 2'b01; // S1
                end else begin
                    current_state <= 2'b00;
                end
            end
            2'b01: begin // S1
                if (data_in == 1'b0) begin
                    current_state <= 2'b10; // S2
                end else begin
                    current_state <= 2'b00;
                end
            end
            2'b10: begin // S2
                if (data_in == 1'b0) begin
                    current_state <= 2'b10; // Stay in S2
                end else if (data_in == 1'b1) begin
                    current_state <= 2'b11; // S3/S4
                end
            end
            2'b11: begin // S3/S4
                if (data_in == 1'b1) begin
                    sequence_detected <= 1'b1;
                end else begin
                    current_state <= 2'b00; // Reset to IDLE
                end
            end
            default: current_state <= 2'b00;
        endcase
    end
end

endmodule