module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] state;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= 3'b000; // IDLE state
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            3'b000: // IDLE state
                if (data_in == 1'b1) begin
                    state <= 3'b001; // Transition to S1 state
                end else begin
                    state <= 3'b000; // Stay in IDLE state
                end
            3'b001: // S1 state
                if (data_in == 1'b0) begin
                    state <= 3'b010; // Transition to S2 state
                end else begin
                    state <= 3'b000; // Return to IDLE state
                end
            3'b010: // S2 state
                if (data_in == 1'b0) begin
                    state <= 3'b011; // Transition to S3 state
                end else begin
                    state <= 3'b000; // Return to IDLE state
                end
            3'b011: // S3 state
                if (data_in == 1'b1) begin
                    state <= 3'b100; // Transition to S4 state
                    sequence_detected <= 1'b1;
                end else begin
                    state <= 3'b000; // Return to IDLE state
                end
            3'b100: // S4 state
                state <= 3'b000; // Return to IDLE state
                sequence_detected <= 1'b0;
            default:
                state <= 3'b000; // Return to IDLE state
        endcase
    end
end

endmodule