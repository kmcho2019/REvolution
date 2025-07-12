module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [23:0] byte_shift_reg;
    reg [1:0] valid_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'b0;
            valid_count <= 2'b0;
            done <= 1'b0;
        end else begin
            // Shift in new byte
            byte_shift_reg <= {byte_shift_reg[15:0], in};
            
            // Check if we've just shifted out a complete message
            done <= (byte_shift_reg[19] && (valid_count == 2'b10));
            
            // Update valid count
            if (byte_shift_reg[19]) begin
                // Start of new message detected
                valid_count <= 2'b01;
            end else if (valid_count != 2'b0) begin
                // Continue counting message bytes
                if (valid_count == 2'b10) begin
                    valid_count <= 2'b0;
                end else begin
                    valid_count <= valid_count + 1'b1;
                end
            end
        end
    end

endmodule