module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states using one-hot encoding
reg [4:0] state;

localparam IDLE = 5'b00001;
localparam S1 = 5'b00010;
localparam S2 = 5'b00100;
localparam S3 = 5'b01000;
localparam S4 = 5'b10000;

// Initialize state to IDLE
initial state = IDLE;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset state to IDLE and sequence_detected to 0
        state <= IDLE;
        sequence_detected <= 0;
    end else if (data_in == 1'b0 || data_in == 1'b1) begin
        // Input validation: only valid binary values (0 or 1)
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    // Transition to S1 on 1 input
                    state <= S1;
                end else begin
                    // Stay in IDLE on 0 input
                    state <= IDLE;
                end
                sequence_detected <= 0;
            end
            S1: begin
                if (data_in == 1'b0) begin
                    // Transition to S2 on 0 input
                    state <= S2;
                end else begin
                    // Reset to IDLE on invalid input
                    state <= IDLE;
                end
                sequence_detected <= 0;
            end
            S2: begin
                if (data_in == 1'b0) begin
                    // Transition to S3 on 0 input
                    state <= S3;
                end else begin
                    // Reset to IDLE on invalid input
                    state <= IDLE;
                end
                sequence_detected <= 0;
            end
            S3: begin
                if (data_in == 1'b1) begin
                    // Transition to S4 on 1 input
                    state <= S4;
                end else begin
                    // Reset to IDLE on invalid input
                    state <= IDLE;
                end
                sequence_detected <= 0;
            end
            S4: begin
                // Transition back to IDLE and set sequence_detected
                state <= IDLE;
                sequence_detected <= 1'b1;
            end
            default: state <= IDLE; // Invalid state, reset to IDLE
        endcase
    end else begin
        // Invalid input, reset to IDLE
        state <= IDLE;
        sequence_detected <= 0;
    end
end

endmodule