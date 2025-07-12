module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // Combined shift/state register
    // [9] - current stop bit position
    // [8:1] - received data bits
    // [0] - start bit (should be 0 when valid)
    reg [9:0] shift_state;
    reg [3:0] bit_counter;

    always @(posedge clk) begin
        if (reset) begin
            shift_state <= 10'b1_11111111_1; // Idle state (all 1s)
            bit_counter <= 0;
            done <= 0;
        end else begin
            // Default assignments
            done <= 0;
            
            // Shift in new bit
            shift_state <= {in, shift_state[9:1]};
            
            // Counter logic
            if (shift_state[0] == 0) begin // If we have a valid start
                bit_counter <= bit_counter + 1;
            end else if (in == 1) begin // Line is idle
                bit_counter <= 0;
            end
            
            // Stop bit detection and done generation
            if (bit_counter == 9 && shift_state[0] == 0) begin
                done <= in; // Stop bit should be 1
                if (in == 0) begin // Bad stop bit
                    bit_counter <= 10; // Force wait for idle
                end else begin
                    bit_counter <= 0; // Ready for next byte
                end
            end
            
            // Automatic reset to idle if we see 8 consecutive 1s
            if (&shift_state[8:1]) begin
                bit_counter <= 0;
            end
        end
    end

endmodule