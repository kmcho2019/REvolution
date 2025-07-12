module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] shift_reg;  // 3-byte shift register

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            shift_reg <= {shift_reg[15:0], in};
            
            // Check if oldest byte in window has in[3]=1 (message start)
            // and we've received 3 bytes (window is full)
            done <= (shift_reg[19:16] == 4'b1000) && 
                   (&shift_reg[23:20]);  // All bits set indicates window is full
        end
    end

    // Alternative implementation with explicit full detection
    /*
    reg [1:0] byte_count;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            byte_count <= 2'b0;
            done <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[15:0], in};
            byte_count <= (byte_count == 2'b10) ? 2'b0 : byte_count + 1'b1;
            done <= (byte_count == 2'b10) && (shift_reg[19:16] == 4'b1000);
        end
    end
    */

endmodule