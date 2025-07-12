module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] write_ptr;  // 3-bit pointer (0-7)
    reg [7:0] data_buffer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize pointer to MSB position (7)
            write_ptr <= 3'd7;
            data_buffer <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default assignment

            if (din_valid) begin
                // Store data at current pointer position
                data_buffer[write_ptr] <= din_serial;

                // Update pointer (circular buffer)
                if (write_ptr == 3'd0) begin
                    write_ptr <= 3'd7;  // Wrap around
                    dout_parallel <= data_buffer;
                    dout_valid <= 1'b1;
                end
                else begin
                    write_ptr <= write_ptr - 3'd1;
                end
            end
        end
    end

endmodule