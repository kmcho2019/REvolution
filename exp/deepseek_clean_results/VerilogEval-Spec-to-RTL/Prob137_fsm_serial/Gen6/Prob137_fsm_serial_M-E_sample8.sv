module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    reg [9:0] shift_reg;  // {state_bit, data[7:0], stop_valid}
    reg [3:0] bit_count;  // Counts 0-9 (4 bits, but only uses 0-8)
    wire receiving = ~shift_reg[9];  // Active when state_bit is 0
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 10'b1_xxxx_xxxx_0;  // Idle state
            bit_count <= 0;
        end else begin
            // Default: maintain current values
            shift_reg <= shift_reg;
            bit_count <= bit_count;
            
            if (receiving) begin
                // Shift in new bit (LSB first)
                shift_reg <= {shift_reg[8:0], in};
                bit_count <= bit_count + 1;
                
                // Check for early stop bit detection
                if (bit_count == 8) begin
                    shift_reg[9] <= in;  // Set state_bit if stop is valid
                    shift_reg[0] <= in;  // Capture stop bit validity
                end
            end else begin
                // In idle state, look for start bit
                if (~in) begin
                    shift_reg <= 10'b0_xxxx_xxxx_0;  // Start receiving
                    bit_count <= 0;
                end
            end
        end
    end

    // Done pulses when stop bit is valid and we return to idle
    assign done = (shift_reg[9] & shift_reg[0]) && (bit_count == 9);

endmodule