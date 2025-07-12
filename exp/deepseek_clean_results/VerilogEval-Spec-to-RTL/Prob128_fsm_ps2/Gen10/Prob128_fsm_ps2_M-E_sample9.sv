module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] byte_shift_reg;  // Stores last 3 bytes (MSB is oldest)
    reg [1:0] byte_counter;     // Counts 0-2 for 3-byte sequences
    wire is_first_byte_valid = byte_shift_reg[23-:8][3];  // Check bit3 of first byte

    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'b0;
            byte_counter <= 2'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte and increment counter
            byte_shift_reg <= {byte_shift_reg[15:0], in};
            byte_counter <= byte_counter + 1;
            
            // Check for message completion when counter wraps
            done <= (byte_counter == 2'b10) && is_first_byte_valid;
        end
    end

endmodule