module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [23:0] byte_shift_reg;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            byte_shift_reg <= 24'b0;
            done_reg <= 1'b0;
        end else begin
            // Shift in new byte
            byte_shift_reg <= {byte_shift_reg[15:0], in};
            
            // Check for complete message with valid start byte
            done_reg <= (byte_shift_reg[19:16] == 4'b1000) ? 1'b1 : 1'b0;
        end
    end

    assign done = done_reg;

endmodule