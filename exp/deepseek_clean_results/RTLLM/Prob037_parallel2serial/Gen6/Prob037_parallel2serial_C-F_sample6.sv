module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] state;
    reg [3:0] shift_reg;
    
    // Next state calculation (simpler than Example 1)
    wire [1:0] next_state = (state == 2'b11) ? 2'b00 : (state + 1'b1);
    
    // Continuous assignments (optimized from both examples)
    assign dout = shift_reg[3];       // Direct MSB output (Example 2)
    assign valid_out = (state == 2'b00); // Valid on first bit (both examples)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b0;
            shift_reg <= 4'b0;
        end else begin
            state <= next_state;
            
            if (state == 2'b11) begin
                // Load new data at state 3 (like Example 2)
                shift_reg <= d;
            end else begin
                // Shift left (optimized from Example 2)
                shift_reg <= {shift_reg[2:0], 1'b0};
            end
        end
    end

endmodule