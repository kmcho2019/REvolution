module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_counter;  // Counts 0-7 (8 bits)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            bit_counter <= 3'b0;
        end else begin
            dout_valid <= 1'b0;  // Default to invalid
            
            if (din_valid) begin
                // Shift in new bit at LSB
                dout_parallel <= {dout_parallel[6:0], din_serial};
                
                // Increment counter
                if (bit_counter == 3'd7) begin
                    bit_counter <= 3'd0;
                    dout_valid <= 1'b1;  // Valid when 8th bit received
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
        end
    end

endmodule