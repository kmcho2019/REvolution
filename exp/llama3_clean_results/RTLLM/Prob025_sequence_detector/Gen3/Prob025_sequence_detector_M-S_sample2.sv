module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] state; // Simplified state variable

always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            if (data_in == 1'b1) begin
                state = 2'b01; // Transition to S1
            end else begin
                state = 2'b00; // Stay in IDLE
            end
        end
        2'b01: begin // S1 state
            if (data_in == 1'b0) begin
                state = 2'b10; // Transition to S2
            end else begin
                state = 2'b00; // Reset to IDLE
            end
        end
        2'b10: begin // S2 state
            if (data_in == 1'b0) begin
                state = 2'b11; // Transition to S3
            end else begin
                state = 2'b00; // Reset to IDLE
            end
        end
        2'b11: begin // S3 state
            if (data_in == 1'b1) begin
                sequence_detected = 1'b1; // Set sequence_detected high
                state = 2'b00; // Reset to IDLE
            end else begin
                state = 2'b00; // Reset to IDLE if sequence not matched
            end
        end
        default: state = 2'b00;
    endcase
end

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= 2'b00;
    end else begin
        // Combinational logic drives the state transition
    end
end

always @(posedge clk) begin
    if (state == 2'b11 && data_in == 1'b1) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule