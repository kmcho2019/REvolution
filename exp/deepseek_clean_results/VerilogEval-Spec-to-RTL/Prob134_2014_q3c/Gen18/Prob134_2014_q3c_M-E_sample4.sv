module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // State processing registers
    reg [2:0] state_bits;
    reg [1:0] bit_counter;
    reg processing_done;
    
    // Next state computation
    reg [2:0] next_state;
    reg next_z;
    
    // Output registers
    reg Y0_reg;
    reg z_reg;
    
    always @(posedge clk) begin
        if (bit_counter == 2'b00) begin
            // Initialize processing
            state_bits <= y;
            bit_counter <= 2'b01;
            processing_done <= 1'b0;
            next_state <= 3'b000;
            next_z <= 1'b0;
        end else if (!processing_done) begin
            // Process each state bit sequentially
            case (bit_counter)
                2'b01: begin // Bit 0
                    case ({state_bits, x})
                        4'b0000: begin next_state[0] <= 0; next_z <= 0; end
                        4'b0001: begin next_state[0] <= 1; next_z <= 0; end
                        4'b0010: begin next_state[0] <= 1; next_z <= 0; end
                        4'b0011: begin next_state[0] <= 0; next_z <= 0; end
                        4'b0100: begin next_state[0] <= 0; next_z <= 0; end
                        4'b0101: begin next_state[0] <= 0; next_z <= 0; end
                        4'b0110: begin next_state[0] <= 1; next_z <= 1; end
                        4'b0111: begin next_state[0] <= 0; next_z <= 1; end
                        4'b1000: begin next_state[0] <= 1; next_z <= 1; end
                        4'b1001: begin next_state[0] <= 0; next_z <= 1; end
                    endcase
                    bit_counter <= 2'b10;
                end
                2'b10: begin // Bit 1
                    case ({state_bits, x})
                        4'b0000: next_state[1] <= 0;
                        4'b0001: next_state[1] <= 0;
                        4'b0010: next_state[1] <= 0;
                        4'b0011: next_state[1] <= 0;
                        4'b0100: next_state[1] <= 1;
                        4'b0101: next_state[1] <= 0;
                        4'b0110: next_state[1] <= 0;
                        4'b0111: next_state[1] <= 1;
                        4'b1000: next_state[1] <= 1;
                        4'b1001: next_state[1] <= 0;
                    endcase
                    bit_counter <= 2'b11;
                end
                2'b11: begin // Bit 2
                    case ({state_bits, x})
                        4'b0000: next_state[2] <= 0;
                        4'b0001: next_state[2] <= 0;
                        4'b0010: next_state[2] <= 0;
                        4'b0011: next_state[2] <= 1;
                        4'b0100: next_state[2] <= 0;
                        4'b0101: next_state[2] <= 0;
                        4'b0110: next_state[2] <= 0;
                        4'b0111: next_state[2] <= 0;
                        4'b1000: next_state[2] <= 0;
                        4'b1001: next_state[2] <= 1;
                    endcase
                    processing_done <= 1'b1;
                    bit_counter <= 2'b00;
                end
            endcase
        end
        
        // Output registration
        if (processing_done) begin
            Y0_reg <= next_state[0];
            z_reg <= next_z;
            processing_done <= 1'b0;
        end
    end
    
    assign Y0 = Y0_reg;
    assign z = z_reg;

endmodule