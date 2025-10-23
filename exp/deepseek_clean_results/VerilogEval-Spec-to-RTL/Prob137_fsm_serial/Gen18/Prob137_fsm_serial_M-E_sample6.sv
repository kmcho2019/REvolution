module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Combined shift register + state tracking
    // [10:3] = data bits (8)
    // [2] = start bit
    // [1] = stop bit expected
    // [0] = active flag
    reg [10:0] shift_state;
    
    wire is_active = shift_state[0];
    wire expecting_stop = shift_state[1];
    wire start_bit_valid = !shift_state[2];
    wire [7:0] received_data = shift_state[10:3];
    
    // Done signal registered
    reg done_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_state <= 11'b0;
            done_reg <= 0;
        end else begin
            // Default done signal
            done_reg <= 0;
            
            // Shift register operation
            if (is_active) begin
                shift_state <= {in, shift_state[10:1]};
                
                // Check for completion (stop bit when expected)
                if (expecting_stop && shift_state[1]) begin
                    done_reg <= in;  // Valid stop bit
                    shift_state[0] <= 0;  // Return to idle
                end
            end
            // Start bit detection
            else if (!in) begin
                // Initialize shift register:
                // - Set active flag
                // - Mark start bit (0)
                // - Prepare to expect stop bit after 8 data bits
                shift_state <= {8'b0, 1'b0, 1'b1, 1'b1};
            end
        end
    end
    
    assign done = done_reg;

endmodule