module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [1:0] state, next_state;

// Initialize the state machine and output on reset
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= 2'b00; // IDLE
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
        
        // Check if the final state is reached
        if (state == 2'b11) begin // S4
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

// State transition logic
always @(*) begin
    case (state)
        2'b00: begin // IDLE
            if (data_in == 1'b1) begin
                next_state = 2'b01; // S1
            end else begin
                next_state = 2'b00; // IDLE
            end
        end
        2'b01: begin // S1
            if (data_in == 1'b0) begin
                next_state = 2'b10; // S2
            end else begin
                next_state = 2'b00; // IDLE
            end
        end
        2'b10: begin // S2
            if (data_in == 1'b0) begin
                next_state = 2'b11; // S3
            end else begin
                next_state = 2'b00; // IDLE
            end
        end
        2'b11: begin // S3
            if (data_in == 1'b1) begin
                next_state = 2'b00; // S4 -> IDLE
            end else begin
                next_state = 2'b00; // IDLE
            end
        end
        default: begin
            next_state = 2'b00; // IDLE
        end
    endcase
end

endmodule