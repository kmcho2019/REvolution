module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] shift_register; // 8-bit shift register to collect incoming bits
reg start_bit_detected; // Flag to indicate start bit detection
reg stop_bit_expected; // Flag to indicate stop bit expectation
reg [2:0] state; // 3-bit state register

// Define states
localparam IDLE = 3'b001;
localparam RECEIVING = 3'b010;
localparam STOP_BIT = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 8'b0; // Reset shift register
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        stop_bit_expected <= 1'b0; // Reset stop bit expectation flag
        state <= IDLE; // Reset state to idle
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    start_bit_detected <= 1'b1; // Set start bit detection flag
                    shift_register <= 8'b0; // Reset shift register
                    state <= RECEIVING; // Transition to receiving state
                end
            end
            RECEIVING: begin
                shift_register <= {shift_register[6:0], in}; // Shift in new bit
                if (shift_register[7]) begin // 8 bits received
                    state <= STOP_BIT; // Transition to stop bit state
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit detected
                    done <= 1'b1; // Set done signal high
                    state <= IDLE; // Transition to idle state
                end else begin // Stop bit not detected
                    state <= IDLE; // Transition to idle state
                end
            end
        endcase
    end
end

// Reset done signal after one clock cycle
always @(posedge clk) begin
    if (done) begin
        done <= 1'b0; // Reset done signal
    end
end

endmodule