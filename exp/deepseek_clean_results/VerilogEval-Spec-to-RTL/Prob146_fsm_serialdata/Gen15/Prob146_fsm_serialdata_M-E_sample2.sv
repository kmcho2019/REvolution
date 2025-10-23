module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Combined shift-state register (1 start + 8 data + 1 stop + 1 overflow)
    reg [10:0] shift_state;
    wire is_start_ok = (shift_state[9] == 1'b0);  // Start bit check
    wire is_stop_ok = (shift_state[0] == 1'b1);   // Stop bit check
    wire is_complete = (&shift_state[9:1]);      // All bits received

    always @(posedge clk) begin
        if (reset) begin
            shift_state <= 11'b111_1111_1111;  // Idle state (all 1s)
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // Shift in new bit
            shift_state <= {in, shift_state[10:1]};
            
            // Check for complete byte with valid stop bit
            if (is_complete && is_start_ok && is_stop_ok) begin
                out_byte <= shift_state[8:1];  // Extract data bits
                done <= 1'b1;
                shift_state <= 11'b111_1111_1111;  // Return to idle
            end
            // Early termination if stop bit fails
            else if (is_complete && !is_stop_ok) begin
                shift_state <= {1'b1, shift_state[10:1]};  // Shift in 1 until stop
            end
        end
    end

endmodule