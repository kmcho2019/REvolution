module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] data_buffer;
    reg [2:0] write_ptr;  // 3-bit pointer (0-7)
    reg wrap_flag;        // Single-bit wrap indicator

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buffer <= 8'b0;
            write_ptr <= 3'b0;
            wrap_flag <= 1'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default to invalid
            
            if (din_valid) begin
                // Store current bit at pointer position
                data_buffer[write_ptr] <= din_serial;
                
                // Update pointer and wrap flag
                wrap_flag <= (write_ptr == 3'd6);  // Set flag one cycle before wrap
                
                if (wrap_flag) begin
                    write_ptr <= 3'd0;
                    dout_parallel <= {data_buffer[6:0], din_serial};
                    dout_valid <= 1'b1;
                end
                else begin
                    write_ptr <= write_ptr + 3'd1;
                end
            end
        end
    end

endmodule