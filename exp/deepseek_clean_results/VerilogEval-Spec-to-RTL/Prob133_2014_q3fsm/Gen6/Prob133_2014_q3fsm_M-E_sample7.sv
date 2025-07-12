module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Combined state encoding: [1] = A(0)/B(1), [0] = cycle count mod 2
    // States: 00 = A, 01 = B_cycle0, 10 = B_cycle1, 11 = B_cycle2
    reg [1:0] state;
    
    reg [1:0] ones_count;  // Count of 1s in current window
    reg next_z;            // Pre-calculated output
    
    // Output is registered for better timing
    reg z_reg;
    assign z = z_reg;
    
    // Combinational logic for state transitions and counting
    always @(*) begin
        next_z = 1'b0;
        
        if (state == 2'b11) begin  // End of counting window
            if (ones_count + w == 2'd2) begin
                next_z = 1'b1;
            end
        end
    end
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;      // State A
            ones_count <= 2'b00;
            z_reg <= 1'b0;
        end else begin
            z_reg <= 1'b0;  // Default output
            
            case (state)
                2'b00: begin  // State A
                    if (s) begin
                        state <= 2'b01;  // Move to B, cycle 0
                        ones_count <= 2'b00;
                    end
                end
                
                2'b01: begin  // B, cycle 0
                    state <= 2'b10;
                    ones_count <= w;
                end
                
                2'b10: begin  // B, cycle 1
                    state <= 2'b11;
                    ones_count <= ones_count + w;
                end
                
                2'b11: begin  // B, cycle 2
                    state <= 2'b01;  // Start new window
                    z_reg <= next_z;
                    ones_count <= w;  // First bit of new window
                end
            endcase
        end
    end

endmodule