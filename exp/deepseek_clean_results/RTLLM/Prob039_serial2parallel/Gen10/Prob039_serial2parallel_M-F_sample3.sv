module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_count <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default value
            
            if (din_valid) begin
                // Shift in new bit (MSB first)
                shift_reg <= {shift_reg[6:0], din_serial};
                
                // Increment counter
                if (bit_count == 3'd7) begin
                    bit_count <= 3'd0;
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                end
                else begin
                    bit_count <= bit_count + 1;
                end
            end
        end
    end

endmodule