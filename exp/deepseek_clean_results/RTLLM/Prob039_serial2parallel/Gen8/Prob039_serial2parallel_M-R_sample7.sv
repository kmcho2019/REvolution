module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_pos;

    // Continuous output assignments
    assign dout_parallel = shift_reg;
    assign dout_valid = (bit_pos == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_pos <= 3'b0;
        end
        else if (din_valid) begin
            // Shift in new bit at current position
            shift_reg <= {shift_reg[6:0], din_serial};
            
            // Update bit position (wraps after 7)
            bit_pos <= (bit_pos == 3'd7) ? 3'b0 : bit_pos + 1'b1;
        end
    end

endmodule