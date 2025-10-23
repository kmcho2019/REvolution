module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] data_buffer;
    reg [2:0] bit_counter;  // 3-bit counter for 0-7

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buffer <= 8'b0;
            bit_counter <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to not valid
            
            if (din_valid) begin
                // Store incoming bit at current position (MSB first)
                data_buffer[7-bit_counter] <= din_serial;
                
                if (bit_counter == 3'd7) begin
                    // On 8th bit, output the complete buffer
                    dout_parallel <= data_buffer;
                    dout_valid <= 1'b1;
                    bit_counter <= 3'b0;
                end
                else begin
                    bit_counter <= bit_counter + 1;
                end
            end
        end
    end

endmodule