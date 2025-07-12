module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit state register
reg [7:0] data_register; // 8-bit register to store incoming data bits
reg [2:0] bit_count; // 3-bit counter to track number of bits received

// Define states
parameter IDLE = 2'b00;
parameter START_BIT = 2'b01;
parameter RECEIVE_BITS = 2'b10;
parameter STOP_BIT = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE; // Reset state to IDLE
        data_register <= 8'b0; // Reset data register
        bit_count <= 3'b0; // Reset counter
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
                    bit_count <= 3'b1; // Increment counter
                    state <= RECEIVE_BITS; // Move to RECEIVE_BITS state
                end else begin // Start bit not verified
                    state <= IDLE; // Move back to IDLE state
                end
            end
            RECEIVE_BITS: begin
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
                if (bit_count == 3'b1000) begin // 8 bits received
                    state <= STOP_BIT; // Move to STOP_BIT state
                end
            end
            STOP_BIT: begin
                if (in) begin // Stop bit detected
                    done <= 1'b1; // Set done signal
                    state <= IDLE; // Move back to IDLE state
                end else begin // Stop bit not detected
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