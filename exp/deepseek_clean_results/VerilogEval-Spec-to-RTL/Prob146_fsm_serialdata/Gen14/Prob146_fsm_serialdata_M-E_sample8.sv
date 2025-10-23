module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Combined shift-state register
    reg [10:0] shift_state;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_state <= 11'b000_0000_0001; // Reset to idle (1 in LSB)
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (shift_state[0]) begin // IDLE state
                if (~in) begin // Start bit detected
                    shift_state <= {10'b0, 1'b1} << 1; // Move marker to start bit position
                end
            end
            else if (shift_state[10]) begin // STOP bit check
                if (in) begin // Valid stop bit
                    out_byte <= shift_state[9:2]; // Capture data bits
                    done <= 1'b1;
                end
                shift_state <= 11'b000_0000_0001; // Return to idle
            end
            else begin // Receiving bits
                shift_state <= {in, shift_state[10:1]}; // Shift in new bit
            end
        end
    end

endmodule