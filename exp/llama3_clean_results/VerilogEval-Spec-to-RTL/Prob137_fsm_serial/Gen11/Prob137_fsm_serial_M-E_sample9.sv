module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3-bit state register
reg [3:0] data_count; // 4-bit counter for data bits
reg [2:0] bit_count; // 3-bit counter for start and stop bits

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset state to IDLE
        data_count <= 4'b0; // Reset data counter
        bit_count <= 3'b0; // Reset bit counter
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 3'b001; // Transition to START state
                    bit_count <= 3'b1; // Increment bit counter
                end
            end
            3'b001: begin // START state
                if (~in) begin // Confirm start bit
                    state <= 3'b010; // Transition to RECEIVE state
                    data_count <= 4'b1; // Increment data counter
                end else begin
                    state <= 3'b000; // Reset to IDLE state
                end
            end
            3'b010: begin // RECEIVE state
                data_count <= data_count + 1; // Increment data counter
                if (data_count == 9) begin // 8 data bits received
                    state <= 3'b011; // Transition to STOP state
                end
            end
            3'b011: begin // STOP state
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                    state <= 3'b000; // Reset to IDLE state
                end else begin
                    state <= 3'b011; // Stay in STOP state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule