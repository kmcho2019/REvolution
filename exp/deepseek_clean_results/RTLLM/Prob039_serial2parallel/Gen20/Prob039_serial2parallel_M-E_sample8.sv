module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // Circular buffer implementation
    reg [7:0] data_buffer;
    reg [2:0] write_ptr;
    reg buffer_full;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_ptr <= 3'b0;
            data_buffer <= 8'b0;
            buffer_full <= 1'b0;
            dout_valid <= 1'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default
            
            // Data collection logic
            if (din_valid && !buffer_full) begin
                data_buffer[write_ptr] <= din_serial;
                
                // Pointer update with circular behavior
                if (write_ptr == 3'd7) begin
                    buffer_full <= 1'b1;
                    write_ptr <= 3'b0;
                end
                else begin
                    write_ptr <= write_ptr + 1'b1;
                end
            end
            
            // Output generation when buffer is full
            if (buffer_full) begin
                dout_parallel <= data_buffer;
                dout_valid <= 1'b1;
                buffer_full <= 1'b0;
            end
        end
    end

endmodule