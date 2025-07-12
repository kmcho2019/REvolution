module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] current_state;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= 2'b00; // IDLE state
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            2'b00: begin // IDLE state
                if (data_in == 1'b1) begin
                    current_state <= 2'b01; // S1 state
                end
                sequence_detected <= 1'b0;
            end
            2'b01: begin // S1 state
                if (data_in == 1'b0) begin
                    current_state <= 2'b10; // S2 state
                end else begin
                    current_state <= 2'b00; // IDLE state
                end
                sequence_detected <= 1'b0;
            end
            2'b10: begin // S2 state
                if (data_in == 1'b0) begin
                    current_state <= 2'b11; // S3 state
                end else begin
                    current_state <= 2'b00; // IDLE state
                end
                sequence_detected <= 1'b0;
            end
            2'b11: begin // S3 state
                if (data_in == 1'b1) begin
                    sequence_detected <= 1'b1;
                end else begin
                    current_state <= 2'b00; // IDLE state
                    sequence_detected <= 1'b0;
                end
                current_state <= 2'b00; // IDLE state
            end
            default: begin
                current_state <= 2'b00; // IDLE state
                sequence_detected <= 1'b0;
            end
        endcase
    end
end

endmodule