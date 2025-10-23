module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] byte_shift_reg;  // Stores last 3 bytes (MSB is newest)
    reg [1:0] fill_counter;
    wire boundary_found;

    // Parallel boundary detection
    assign boundary_found = (byte_shift_reg[23:16][3] &&  // Byte1 in position
                           (fill_counter == 2'd2));       // All 3 bytes received

    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'b0;
            fill_counter <= 2'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_shift_reg <= {byte_shift_reg[15:0], in};
            
            // Update fill counter
            if (boundary_found) begin
                fill_counter <= 2'b0;  // Reset on message detection
            end else if (fill_counter != 2'd2) begin
                fill_counter <= fill_counter + 1'b1;
            end

            // Output done signal
            done <= boundary_found;
        end
    end

endmodule