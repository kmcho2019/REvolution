module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg circular_mode;  // Control signal for mode selection
    
    // Default to shift mode (0) unless changed
    initial circular_mode = 1'b0;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            if (circular_mode) begin
                // Circular shift: MSB goes to LSB
                shift_reg <= {shift_reg[2:0], shift_reg[3]};
            end else begin
                // Standard shift operation
                shift_reg <= {shift_reg[2:0], in};
            end
        end
    end
    
    // Output is always the MSB of the shift register
    assign out = shift_reg[3];
    
    // Optional: Add this to make circular_mode controllable
    // always @(posedge clk) begin
    //     if (!resetn)
    //         circular_mode <= 1'b0;
    //     else
    //         circular_mode <= new_mode;  // Where new_mode would be an input
    // end

endmodule