module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    reg [9:0] frame_shift;  // Stores start + 8 data + stop bits
    reg [3:0] bit_counter;  // Counts 0-9 (10 bits total)
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            frame_shift <= 10'b0;
            bit_counter <= 4'b0;
            done_reg <= 1'b0;
        end else begin
            // Shift in new bit
            frame_shift <= {in, frame_shift[9:1]};
            
            // Update counter (wrap around after 9)
            bit_counter <= (bit_counter == 4'd9) ? 4'b0 : bit_counter + 1;
            
            // Check for complete valid frame when counter wraps
            done_reg <= (bit_counter == 4'd9) && 
                        (frame_shift[0] == 1'b0) &&  // Start bit valid
                        (in == 1'b1);                // Stop bit valid (current input)
        end
    end

    assign done = done_reg;

endmodule