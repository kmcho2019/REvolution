module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_counter;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_counter <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default to not valid
            
            if (din_valid) begin
                // Shift in new bit at current position
                shift_reg[7-bit_counter] <= din_serial;
                
                if (bit_counter == 3'd7) begin
                    // When we have 8 bits, output them
                    dout_parallel <= shift_reg;
                    dout_valid <= 1'b1;
                    bit_counter <= 3'b0;
                end else begin
                    bit_counter <= bit_counter + 1'b1;
                end
            end
        end
    end

endmodule