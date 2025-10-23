module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] state;  // One-hot state: bit 0=first bit, bit 7=last bit
    reg [7:0] shift_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 8'b00000001;  // Start at first bit
            shift_reg <= 8'b0;
            dout_valid <= 1'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to invalid
            
            if (din_valid) begin
                // Shift in new bit
                shift_reg <= {shift_reg[6:0], din_serial};
                
                // Update state
                if (state[7]) begin
                    // On 8th bit, capture output and reset
                    state <= 8'b00000001;
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                end
                else begin
                    // Move to next state
                    state <= {state[6:0], 1'b0};
                end
            end
        end
    end

endmodule