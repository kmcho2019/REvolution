module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

reg [1:0] state, next_state;

always @(posedge clk) begin
    if (~reset_n) begin
        state <= 2'b00; // IDLE state
    end else begin
        state <= next_state;
    end
end

always @(posedge clk) begin
    if (~reset_n) begin
        sequence_detected <= 1'b0;
    end else if (state == 2'b11 && data_in == 1'b1) begin // S3 state and last bit is 1
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            if (data_in == 1'b1) begin
                next_state = 2'b01; // S1 state
            end else begin
                next_state = 2'b00; // Stay in IDLE
            end
        end
        2'b01: begin // S1 state
            if (data_in == 1'b0) begin
                next_state = 2'b10; // S2 state
            end else begin
                next_state = 2'b00; // Go back to IDLE
            end
        end
        2'b10: begin // S2 state
            if (data_in == 1'b0) begin
                next_state = 2'b11; // S3 state
            end else begin
                next_state = 2'b00; // Go back to IDLE
            end
        end
        2'b11: begin // S3 state
            if (data_in == 1'b1) begin
                next_state = 2'b00; // Go back to IDLE after detecting sequence
            end else begin
                next_state = 2'b00; // Go back to IDLE
            end
        end
    endcase
end

endmodule