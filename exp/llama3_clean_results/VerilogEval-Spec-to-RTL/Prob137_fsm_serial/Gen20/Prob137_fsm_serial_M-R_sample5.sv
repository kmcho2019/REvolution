module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state; // 2-bit binary encoded state register
reg [7:0] data; // 8-bit data register

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        data <= 8'b0; // Reset data register
        done <= 1'b0; // Reset done signal
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 2'b01; // Move to RECEIVE state
                    data <= {7'b0, in}; // Load start bit into data register
                end
            end
            2'b01: begin // RECEIVE state
                data <= {data[6:0], in}; // Shift in new bit
                if (data[7]) begin // 8 bits received
                    if (in) begin // Stop bit correct
                        done <= 1'b1; // Set done signal high
                        state <= 2'b00; // Move back to IDLE state
                    end else begin // Stop bit incorrect
                        state <= 2'b10; // Move to ERROR state
                    end
                end
            end
            2'b10: begin // ERROR state
                if (in) begin // Stop bit detected
                    state <= 2'b00; // Move back to IDLE state
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule