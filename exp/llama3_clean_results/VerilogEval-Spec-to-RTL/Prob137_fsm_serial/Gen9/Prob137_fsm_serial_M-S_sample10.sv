module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [8:0] shift_register; // 9-bit shift register to collect incoming bits
reg receiving; // Flag to indicate receiving state

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 9'b0; // Reset shift register
        receiving <= 1'b0; // Reset receiving flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~receiving) begin // IDLE state
            if (~in) begin // Start bit detected
                receiving <= 1'b1; // Set receiving flag
                shift_register <= {8'b0, in}; // Load start bit into shift register
            end else if (in) begin // Wait stop bit
                // Do nothing
            end
        end else begin // RECEIVE state
            shift_register <= {shift_register[7:0], in}; // Shift in new bit
            if (shift_register[8]) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                end
                receiving <= 1'b0; // Reset receiving flag
            end
        end
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule