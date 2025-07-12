module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3-bit state register
reg [7:0] data_register; // 8-bit register to store incoming data bits
reg [3:0] bit_count; // 4-bit counter to track number of bits received
reg stop_bit_detected; // Flag to indicate stop bit detection

// Define states
parameter IDLE = 3'b000;
parameter START_BIT = 3'b001;
parameter DATA_BITS = 3'b010;
parameter STOP_BIT = 3'b011;
parameter ERROR = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE; // Reset state to IDLE
        data_register <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        stop_bit_detected <= 1'b0; // Reset stop bit detection flag
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= START_BIT; // Move to START_BIT state
                end
            end
            START_BIT: begin
                if (~in) begin // Start bit verified
                    data_register <= 8'b0; // Reset data register
                    bit_count <= 4'b1; // Increment counter
                    state <= DATA_BITS; // Move to DATA_BITS state
                end else begin // Start bit not verified
                    state <= IDLE; // Move back to IDLE state
                end
            end
            DATA_BITS: begin
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 4'b1000) begin // 8 bits received
                    state <= STOP_BIT; // Move to STOP_BIT state
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit detected
                    stop_bit_detected <= 1'b1; // Set stop bit detection flag
                    state <= IDLE; // Move back to IDLE state
                    done <= 1'b1; // Set done signal
                end else begin // Stop bit not detected
                    state <= ERROR; // Move to ERROR state
                end
            end
            ERROR: begin
                if (in) begin // Stop bit detected in ERROR state
                    stop_bit_detected <= 1'b1; // Set stop bit detection flag
                    state <= IDLE; // Move back to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule