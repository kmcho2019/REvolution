module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default value
            
            if (din_valid) begin
                // Shift new bit into MSB (MSB-first ordering)
                shift_reg <= {din_serial, shift_reg[7:1]};
                
                // Increment bit counter
                bit_cnt <= bit_cnt + 1;
                
                // Check if we've received 8 bits
                if (bit_cnt == 3'd7) begin
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid <= 1'b1;
                    bit_cnt <= 3'b0;
                end
            end
        end
    end

endmodule